% JoinInputs (COSIVINA toolbox)
%   


classdef JoinInputs < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed);
    components = {'output'};
    defaultOutputComponent = 'output';
    
  end
  
  properties
    % parameters
    size = [1, 1];
            
    % accessible structures
    output
  end

  
  methods
    % constructor
    function obj = JoinInputs(label,size)
        obj.label = label;
        if numel(size) == 1
            obj.size = [1 size];
        else
            obj.size = size; 
        end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
        for i = 1:obj.nInputs
          obj.output(:,i) = obj.inputElements{i}.(obj.inputComponents{i});
        end
    end
    
    
    % initialization
    function obj = init(obj)
      obj.output = zeros(obj.size);
    end

  end
end


