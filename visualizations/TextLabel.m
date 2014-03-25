% TextLabel (COSIVINA toolbox)
%   Simple text visualization.
%
% Author: Erik Billing (erik.billing@his.se). 


classdef TextLabel < Visualization
  properties
    labelHandle
    simulator
    
    text
  end
  
  
  methods
    % Constructor
    function obj = TextLabel(text, position)
      obj.text = text;
      obj.position = [];
      if nargin > 1
          obj.position = position;
      end
    end
    
    
    % connect to simulator object
    function obj = connect(obj, simulatorHandle)
        obj.simulator = simulatorHandle;
    end
    
    
    % initialization
    function obj = init(obj, figureHandle)
        obj.labelHandle = uicontrol(figureHandle,'Style','text', 'String',obj.text,'units','norm','Position',obj.position);
    end
    
    
    % update
    function obj = update(obj)
%       set(obj.plotHandle, 'ZData', obj.plotElementHandle.(obj.plotComponent));
        obj.simulator
    end
    
    % check control object and update simulator object if required
    function changed = check(obj)
      changed = 0;
    end
    
  end
  
end

