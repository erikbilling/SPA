% Cursor (COSIVINA toolbox)

classdef Cursor < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed, 'amplitude',ParameterStatus.Fixed, 'pos', ParameterStatus.Fixed);
    components = {'output','pos'};
    defaultOutputComponent = 'output';
    
  end
  
  properties
    % parameters
    size = [1, 1];
    amplitude = 1;
    pos = [1, 1];
    lock = false;
    
    % accessible structures
    output
    xRange
    yRange
  end

  
  methods
    % constructor
    function obj = Cursor(label, size, startPos, amplitude)
        obj.label = label;
        obj.size = size;
        obj.pos = startPos;
        obj.amplitude = amplitude;
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
      if ~obj.lock
        obj.updatePosition;
        obj.output = gauss2d(obj.yRange,obj.xRange,obj.pos(1),obj.pos(2),2,2)*obj.amplitude;
      end
    end
    
    function obj = updatePosition(obj)
        if ~isempty(obj.inputElements)
            if ~isnan(obj.inputElements{1}.(obj.inputComponents{1}))
                diff = obj.inputElements{1}.(obj.inputComponents{1})-obj.pos;
                obj.pos = obj.pos+diff/4;
            end
        end
    end
    
    
    % initialization
    function obj = init(obj)
        obj.output = zeros(obj.size);
        obj.xRange = 1:obj.size(2);
        obj.yRange = 1:obj.size(1);
    end

  end
end


