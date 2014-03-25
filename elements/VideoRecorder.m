% VideoRecorder (COSIVINA toolbox)
%   Element that records video from specified figure/axis handle using the
%   standard VideoWriter object. 
%
% Constructor call:
% VideoRecorder(label, handle, autostart)
%   label - element label & filename of video output file
%   handle - handle to source figure/axis (default = figure 1)
%   autostart - specifies weather video recording should autostart
%     (default = false)
%
% Public parameters:
%   record - used to control video recording. While true, one frame will be
%     grabbed for every step. When switched to false, the video is closed
%     and a new video is created if record is set to true again. 
%
% Author: Erik Billing (erik.billing@his.se). 

classdef VideoRecorder < Element
  
  properties (Constant)
    parameters = struct;
    components = {'output'};
    defaultOutputComponent = 'output';
  end
  
  properties
    % parameters
    handle;
    rect = [];
        
    % accessible structures
    output
    video = [];
    record = false;    
  end
  
  methods
    % constructor
    function obj = VideoRecorder(label,handle,rect,autostart)
        obj.label = label;
        if nargin > 1
            obj.handle = handle;
        else
            obj.handle = 1;
        end
        if nargin > 2
            obj.rect = rect;
        end
        if nargin > 3
            obj.record = autostart;
        end
    end
    
    function delete(obj)
        if ~isempty(obj.video)
            close(obj.video)
        end
        delete@Element(obj);
    end
    
    
    % step function
    function obj = step(obj, time, deltaT) %#ok<INUSD>
        if obj.record
            if isempty(obj.video)
                obj.video = VideoWriter(obj.getFileName);
                open(obj.video);
            end
            frame = getframe(obj.handle,obj.rect);
            writeVideo(obj.video,frame);
            obj.output = frame;
        elseif ~isempty(obj.video)            
            close(obj.video);
            obj.video = [];
        end
    end
    
    function fileName = getFileName(obj)
        fileName = [obj.label '.avi'];
        if exist(fileName,'file') == 0
            return;
        else
            for i=1:1000
                fileName = [obj.label '-' int2str(i) '.avi'];
                if exist(fileName,'file') == 0
                    return;
                end
            end
        end
    end
    
    % initialization
    function obj = init(obj)
        obj.output = [];
    end
      
  end
end


