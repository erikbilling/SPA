classdef EBMap < Element

    properties (Constant)
        parameters = struct('size', ParameterStatus.Fixed, 'm', ParameterStatus.Fixed, 'cm', ParameterStatus.Fixed);
        components = {'output','display'};
        defaultOutputComponent = 'output';
    end
    
    properties
        size;
        matrix;
        padding = [0 0];
        changes = {};
        changeTimes = [];
        noise = 0.1;
        
        epuckPose = [];
        
        output;
        display;
    end
    
    methods
        function obj = EBMap(label,matrix,padding,noise)
          obj.label = label;
          obj.size = size(matrix);
          obj.matrix = matrix;
          
          if nargin >=3
            obj.padding = padding;
          end
          if nargin >=4
            obj.noise = noise;
          end
        end       
        
        function addChange(obj,time,rangeY,rangeX,values)
            obj.changeTimes(end+1)=time;
            obj.changes{end+1}={rangeY,rangeX,values};
        end
        
        % step function
        function obj = step(obj, time, deltaT) %#ok<INUSD>
          for c = find(obj.changeTimes==time)
            change = obj.changes{c};
            obj.matrix(change{1},change{2}) = change{3};
          end
          obj.output = -obj.matrix;
          
          if obj.nInputs > 0
            obj.display = obj.matrix;
            inputColorId = 1;
            for i = 1:obj.nInputs
                p = obj.inputElements{i}.(obj.inputComponents{i});
                if numel(p) == 2
                  inputColorId = inputColorId+1;
                  
                  if ~all(isnan(p)) && all(p)
                      p = round(p);
                      px = (-1:1)+p(2);
                      py = (-1:1)+p(1);
                      px(px<1) = 1;
                      py(py<1) = 1;
                      px(px>obj.size(2)) = obj.size(2);
                      py(py>obj.size(1)) = obj.size(1);
                      obj.display(py,px)=inputColorId;
                  end
                else
                  obj.output = obj.output + p;
                  obj.display = obj.display + p;
                end
            end
          end

%           p = obj.inputElements{1}.(obj.inputComponents{1});
%           sigma = 12;
%           obj.epuckPose = gauss2d(1:obj.size(1),1:obj.size(2),p(1),p(2),sigma,sigma)>0.5;
%           obj.output(obj.epuckPose) = -obj.matrix(obj.epuckPose);
          
          obj.output = obj.output + randn(obj.size) * obj.noise;
        end
        
        % initialization
        function obj = init(obj)
          obj.matrix = obj.initPadding(obj.matrix);
          obj.display = obj.matrix;
%           obj.output = -obj.matrix;
          obj.output = -obj.initPadding(zeros(obj.size));
        end
        
        function matrix = initPadding(obj,matrix)
          matrix(1:obj.padding(2),:) = 1;
          matrix(end-obj.padding(2):end,:) = 1;
          matrix(:,1:obj.padding(1),:) = 1;
          matrix(:,end-obj.padding(1):end) = 1;
        end
    end
end

