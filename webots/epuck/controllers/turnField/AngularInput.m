% AngularInput (COSIVINA toolbox)
%   Element transforming a angular input (rad) to a gaussian field input
%
% Constructor call:
% ScaleInput(label, size, amplitude)
%   label - element label
%   size - size of input and output
%   amplitude - scaling factor


classdef AngularInput < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed, 'amplitude', ParameterStatus.Changeable);
    components = {'output'};
    defaultOutputComponent = 'output';
  end
  
  properties
    % parameters
    size = [1, 1];
    sigma = 1;
    amplitude = 0;
        
    % accessible structures
    output
  end
  
  methods
    % constructor
    function obj = AngularInput(label, size, sigma, amplitude)
      obj.label = label;
      obj.size = size;
      
      if nargin >= 3
        obj.sigma = sigma;
      end
      if nargin >= 4
        obj.amplitude = amplitude;
      end

      if numel(obj.size) == 1
        obj.size = [1, obj.size];
      end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
%       obj.inputElements{1}.(obj.inputComponents{1})
      pos = obj.size(2) / 2 + obj.size(2) * obj.inputElements{1}.(obj.inputComponents{1}) / (2*pi);
      pos = mod(pos,obj.size(2));
      obj.output = gauss(1:obj.size(2),pos,obj.sigma).*obj.amplitude;
    end
    
    
    % initialization
    function obj = init(obj)
      obj.output = zeros(obj.size);
    end
      
  end
end


