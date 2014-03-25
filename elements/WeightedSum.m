% WeightedSum (COSIVINA toolbox)
%   Element that computes the sum of inputs, multiplied with specified
%   weights
%
% Constructor call:
% WeightedSum(label, outputSize, weights)
%   sumDimensions - dimension(s) of the input over which sum is computed
%     (can be 1, 2, or [1, 2])
%   outputSize - size of the resulting output
%   amplitude - scalar value that is multiplied with the formed sum


classdef WeightedSum < Element
  
  properties (Constant)
    parameters = struct('weights', ParameterStatus.Changeable, 'size', ParameterStatus.Fixed); 
    components = {'output'};
    defaultOutputComponent = 'output';
  end
  
  properties
    % parameters
    weights = 0;
    size = [1, 1];
        
    % accessible structures
    output
  end
  
  methods
    % constructor
    function obj = WeightedSum(label, outputSize, weights)
      obj.label = label;
      obj.size = outputSize;
      
      if nargin >= 3
        obj.weights = weights;
      end      

      if numel(obj.size) == 1
        obj.size = [1, obj.size];
      end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
      wi = obj.inputElements{1}.(obj.inputComponents{1}) .* obj.weights;
      obj.output = reshape(sum(wi(:)), [obj.size]);
    end
    
    
    % initialization
    function obj = init(obj)
      obj.output = zeros(obj.size);
    end
      
  end
end


