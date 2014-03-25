classdef EBPlot2d < ScaledImage
    
    methods
        function obj = EBPlot2d(eb,plotComponent,plotRange,axesProperties, imageProperties, title, xlabel, ylabel, position)
            if nargin < 2
                plotComponent = 'activation';
            end
            if nargin < 3
                plotRange = [-10 20];
            end
            if nargin < 4
                axesProperties = {};
            end
            if nargin < 5
                imageProperties = {};
            end
            if nargin < 6
                title = eb.label;
            end
            if nargin < 7
                xlabel = '';
            end
            if nargin < 8
                ylabel = '';
            end
            if nargin < 9
                position = [];
            end
            inputElements = {[eb.label '.motivation'],[eb.label '.precondition'],[eb.label '.intention'],[eb.label '.cos']};
            inputComponents = {plotComponent,plotComponent,plotComponent,plotComponent};
            eb.sim.addElement(EBField([eb.label '.field'],eb.size),inputElements,inputComponents);
            obj = obj@ScaledImage([eb.label '.field'],'output',plotRange,axesProperties,imageProperties,title,xlabel,ylabel,position);
        end
        
        function obj = init(obj, figureHandle)
            obj = init@ScaledImage(obj,figureHandle);
%             colorbar;
        end
    end
    
end

