classdef EPuckController < Element
    properties (Constant)
    parameters = struct();
    components = {'output','psField','position','heading','goal','obstacles'};
    defaultOutputComponent = 'output';
    
    sensorCount = 8;
    timeStep = 64;
%     timeStep = 25;
    maxRotation = 400;
    
    poseOffset = 5;
  end
  
  properties
    % parameters
    size = [1 100];
    psSize = 100;
    
    % events
    goal;
    obstacles;
    
    % accessible structures
    output;
    ps = [] % proximity sensors
    psField;
    position = [0 0];
    heading = 0;
    maxSpeed = 0;
    display;
    camera;
    emitter;
    receiver;
  end

  
  methods
    % constructor
    function obj = EPuckController(label,size,psSize)
      if nargin > 0
        obj.label = label;
      end
      if nargin > 1
        obj.size = size;
      end
      if nargin > 2
        obj.psSize = psSize;
      end
    end
    
    function values = readProximitySensors(obj,sensors)
        if nargin < 2
            sensors = 1:8;
        end
        values = NaN(1,length(sensors));
        for s = sensors
            values(s) = wb_distance_sensor_get_value(obj.ps(s));
        end
    end
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
      wb_robot_step(obj.timeStep);

      % convert to null-terminated 8 bit ascii string
      message = uint8([datestr(now) 0]);
      wb_emitter_send(obj.emitter, message);

      obj.updateReceiver;      
      obj.updateWheelSpeeds;
      obj.updatePsField;
    end
    
    function obj = updateWheelSpeeds(obj)
      lws = obj.inputElements{1}.(obj.inputComponents{1});
      rws = obj.inputElements{2}.(obj.inputComponents{2});
      
      obj.setSpeed(lws,rws);
    end
    
    function obj = stop(obj)
        wb_differential_wheels_set_speed(0,0);
    end
    
    function obj = updatePsField(obj)
      range = 1:obj.psSize;
      sigma = 3;
      psvalues = obj.readProximitySensors;
      psvalues(psvalues < 0) = 0;
      values = log(1+psvalues/50).*5;
%       obj.psField = ...
%         gauss(range,55,sigma) .* values(1) + ...
%         gauss(range,65,sigma) .* values(2) + ...
%         gauss(range,75,sigma) .* values(3) + ...
%         gauss(range,95,sigma) .* values(4) + ...
%         gauss(range, 5,sigma) .* values(5) + ...
%         gauss(range,25,sigma) .* values(6) + ...
%         gauss(range,35,sigma) .* values(7) + ...
%         gauss(range,45,sigma) .* values(8);
      obj.psField = ...
        gauss(range, 55,sigma) .* values(1) + ...
        gauss(range, 65,sigma) .* values(2) + ...
        gauss(range, 90,sigma) .* values(3) * .5 + ...
        gauss(range,100,sigma) .* values(4) * .5 + ...
        gauss(range,  1,sigma) .* values(5) * .5 + ...
        gauss(range, 10,sigma) .* values(6) * .5 + ...
        gauss(range,35,sigma) .* values(7) + ...
        gauss(range,45,sigma) .* values(8);
    end
    
    function [S, D] = signalStrengths(obj)
      % Eq. A.3 from Sandamirskaya 2010, NN. 
      b1 = 1;
      b2 = 2;
      D = 70*exp(-0.007*obj.readProximitySensors); % mm
      S = b1 * exp(-D/b2);
    end
    
    function fObs = obstacleForce(obj,headingAngle)
      % Eq. A.2 from Sandamirskaya 2010, NN. 
      robotRadius = 40; 
      headingDirection = pi/2;
      [s, d] = obj.signalStrengths;
      sensorAngles = [1.27, 0.77, 0.00, 5.21, 4.21, 3.14, 2.37, 1.87];
      relativeAngle = mod(pi+sensorAngles-headingDirection,2*pi)-pi;
%       rObs = atan(tan(pi/8) + robotRadius ./ (robotRadius + d));
%       fObs = s .* exp(-abs(relativeAngle)./(2.*rObs.*rObs));
%       fObs = sum(fObs);
      
      % Page 5 from Summer school lecture slides, ATTRACTOR DYNAMICS APPROACH TO BEHAVIOR GENERATION
      sigma = 1;
      fObs = s .* relativeAngle .* exp(-(relativeAngle.*relativeAngle)./(2*sigma*sigma));
      fObs = sum(fObs) .* 1000;
    end
    
    function speeds = headingSpeeds(obj,linearSpeed,angularSpeed)
      dyx = obj.target - obj.position;
      v = atan2(dyx(1),dyx(2));
      dv = obj.heading+v;
      
      if dv>pi
          dv = dv-pi*2;
      elseif dv<-pi
          dv = dv+pi*2;
      end

      odv = obj.obstacleForce(dv);
      speed = sum(dyx.*dyx) * 0.8 * linearSpeed;
      speed(speed>linearSpeed) = linearSpeed;
      speeds = [speed+dv*angularSpeed, speed-dv*angularSpeed];
    end
    
    function obj = setSpeed(obj,lws,rws)
        if nargin == 2 && length(lws) == 2
            rws = lws(2);
            lws = lws(1);
        end
        rotationReduction = obj.maxRotation / abs(lws-rws);
        if rotationReduction < 1
            lws = lws*rotationReduction;
            rws = rws*rotationReduction;
        end
        wb_differential_wheels_set_speed(lws,rws);
    end
    
    function obj = updateReceiver(obj)
      ID_GOAL = 0;
      ID_POSE = 1;
      ID_OBSTACLE_APPEAR = 2;
      ID_OBSTACLE_DISAPPEAR = 3;
      global noiseLevel;
      
      while wb_receiver_get_queue_length(obj.receiver) > 0
        v = wb_receiver_get_data(obj.receiver,'double');
        wb_receiver_next_packet(obj.receiver);
      
        if ~isnan(v)
          if v(1) == ID_GOAL
            obj.goal = v(2:3);
            fprintf('Goal set to [%.0f %.0f]\n',obj.goal(2),obj.goal(1));
          elseif v(1) == ID_POSE
            y = (v(2)+0.95)*100+5+obj.poseOffset;
            x = (v(4)-0.95)*-100+5+obj.poseOffset;

            outputPower = 1;
            if noiseLevel >= 1
              y = y + randn*2;
              x = x + randn*2;
              outputPower = 1.2;
            elseif noiseLevel > 0.01
              y = y + randn*.5;
              x = x + randn*.5;
            end

            obj.position = [y x];
            obj.heading = v(8) .* sign(v(6));
            obj.output = gauss2d(1:obj.size(1),1:obj.size(2),y,x,3,3) * outputPower;   
          elseif v(1) == ID_OBSTACLE_APPEAR || v(1) == ID_OBSTACLE_DISAPPEAR
            y = (v(2)+0.95)*100+5+obj.poseOffset;
            x = (v(4)-0.95)*-100+5+obj.poseOffset;
            w = v(5) * 100 / 2;
            h = v(7) * 100 / 2;
            yrange = round(y+(-h:h));
            xrange = round(x+(-w:w));
            yrange = yrange(yrange>0 & yrange < obj.size(1));
            xrange = xrange(xrange>0 & xrange < obj.size(2));
            obstacleValue = -1 * (v(1)==ID_OBSTACLE_APPEAR);
            obj.obstacles(yrange,xrange) = obstacleValue;
          end
        end
      end 
    end
    
    
    % initialization
    function obj = init(obj)
        % get and enable all distance sensors
        obj.psField = zeros(1,obj.psSize);
        obj.ps = NaN(1,obj.sensorCount);
        for i=1:obj.sensorCount
          obj.ps(i) = wb_robot_get_device(['ps' int2str(i-1)]);
          wb_distance_sensor_enable(obj.ps(i),obj.timeStep);
        end
        
        % get the display (not a real e-puck device !)
%         obj.display = wb_robot_get_device('display');
%         wb_display_set_color(obj.display, [0 0 0]);

        % get and enable camera
        obj.camera = wb_robot_get_device('camera');
        wb_camera_enable(obj.camera,obj.timeStep);

        % get and enable emitter and receiver
        obj.emitter = wb_robot_get_device('emitter');
        obj.receiver = wb_robot_get_device('receiver');
        wb_receiver_enable(obj.receiver,obj.timeStep);

        wb_differential_wheels_enable_encoders(obj.timeStep*4);
        obj.maxSpeed = wb_differential_wheels_get_max_speed();
        
        obj.output = zeros(obj.size);
        obj.goal = [0 0];
        obj.obstacles = zeros(obj.size);
    end

  end
    
end

