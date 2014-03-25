% AngularDisplace (COSIVINA toolbox)
%   Element ...
%
% Constructor call:
% AngularDiff(label, size, sigma, amplitude)
%   label - element label
%   size - size of input and output
%   sigma - 
%   amplitude - scaling factor


classdef AngularDisplace < Element
  
  properties (Constant)
    parameters = struct('size', ParameterStatus.Fixed, 'amplitude', ParameterStatus.Changeable);
    components = {'output'};
    defaultOutputComponent = 'output';
  end
  
  properties
    % parameters
    size = [1, 1];
    baseAngle = 0;
    sigma = 1;
    amplitude = 0;
        
    % accessible structures
    output
  end
  
  methods
    % constructor
    function obj = AngularDisplace(label, size, baseAngle, sigma, amplitude)
      obj.label = label;
      obj.size = size;
      
      if nargin >= 3
        obj.baseAngle = baseAngle;
      end
      if nargin >= 4
        obj.sigma = sigma;
      end
      if nargin >= 5
        obj.amplitude = amplitude;
      end

      if numel(obj.size) == 1
        obj.size = [1, obj.size];
      end
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
      angle = obj.inputElements{1}.(obj.inputComponents{1});
      if obj.nInputs > 1
        amp = obj.inputElements{2}.(obj.inputComponents{2});
        amp = max(amp(:)) .* obj.amplitude;
      else
        amp = obj.amplitude;
      end
      
      da = mod(angle-obj.baseAngle,2*pi);
      pos = obj.size(2) / 2 + obj.size(2) * da / (2*pi);
      pos = mod(pos,obj.size(2));
      obj.output = gauss(1:obj.size(2),pos,obj.sigma).*amp;
    end
    
    
    % initialization
    function obj = init(obj)
      obj.output = zeros(obj.size);
    end
      
  end
end


