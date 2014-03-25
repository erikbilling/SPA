% TimeLabel (COSIVINA toolbox)
%   Simple text visualization displaying the current time step.
%
% TimeLabel(text, position)
% text - a printf format string where the current time is provided as
%   first argument
% position - position of the control in the GUI figure window in relative
%   coordinates (optional, is overwritten when specifying a grid position
%   in the GUI’s addVisualization function)
%
% Author: Erik Billing (erik.billing@his.se). 

classdef TimeLabel < TextLabel
    
    methods
        % Constructor
        function obj = TimeLabel(text, position)
            superArgs = {};
            if nargin > 0
                superArgs{1} = text;
            else
                superArgs{1} = '%d';
            end
            if nargin > 1
                superArgs{2} = position;
            end
            obj = obj@TextLabel(superArgs{:});
        end
    
        % check control object and update simulator object if required
        function changed = check(obj)
            set(obj.labelHandle,'String',sprintf(obj.text,obj.simulator.t));
            changed = 1;
        end
    end
    
end

