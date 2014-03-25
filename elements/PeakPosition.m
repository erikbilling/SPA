classdef PeakPosition < Element
    
    properties (Constant)
        parameters = struct;
        components = {'output'};
        defaultOutputComponent = 'output';
    end
    
    properties
        output;
    end
    
    methods
        % constructor
        function obj = PeakPosition(label)
            obj.label = label;
        end


        % step function
        function obj = step(obj, time, deltaT)  %#ok<INUSD>
            m = obj.inputElements{1}.(obj.inputComponents{1});
            for i = 2:length(obj.inputElements)
                m = m+obj.inputElements{i}.(obj.inputComponents{i});
            end
            if m < 0.5
                obj.output = [NaN, NaN];
            else
                ySum = sum(m,2)';
                xSum = sum(m,1);
                yRange = 1:size(m,1);
                xRange = 1:size(m,2);
                y = sum(ySum.*yRange)./sum(ySum);
                x = sum(xSum.*xRange)./sum(xSum);
                obj.output = [y,x];
            end
        end

        % intialization
        function obj = init(obj)
          obj.output = [NaN NaN];
        end
    end
    
end

