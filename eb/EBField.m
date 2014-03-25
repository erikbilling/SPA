% EBField (COSIVINA toolbox)
%   A combined field representation of the four partial EB fields where the
%   motivation, precondition, intention and cos fields are placed to the
%   upper left, lower left, lower right, and upper right, respectively. 
%
%   Motivation, precondition, intention and cos should be given as inputs
%   in the order specified here. 
%
% Constructor call:
% EBField(label, size)
%   label - element label
%   size - size of the input fields. The output size will double this size

classdef EBField < Element
    
    properties (Constant)
        parameters = struct('size', ParameterStatus.Fixed);
        components = {'output'};
        defaultOutputComponent = 'output';
    end
    
    properties
        size;
        
        output;
        map;
    end
    
    methods
        function obj = EBField(label, size)
            obj.label = label;
            obj.size = size;
            
        end
        
        % step function
        function obj = step(obj, time, deltaT) %#ok<INUSD>
            obj.output(obj.map(1,:))=obj.inputElements{1}.(obj.inputComponents{1});
            obj.output(obj.map(2,:))=obj.inputElements{2}.(obj.inputComponents{2});
            obj.output(obj.map(3,:))=obj.inputElements{3}.(obj.inputComponents{3});
            obj.output(obj.map(4,:))=obj.inputElements{4}.(obj.inputComponents{4});
            
            
            
        end


        % initialization
        function obj = init(obj)
            s = obj.size;
            obj.output = zeros(s*2+1);
            obj.map = zeros(4,prod(s));
            motivation = mapRegion(1:s(1),1:s(1),s*2+1);
            obj.map(1,:) = motivation(:);
            precondition = mapRegion((1:s(1))+s(1)+1,(1:s(1)),s*2+1);
            obj.map(2,:) =  precondition(:);
            intention = mapRegion((1:s(1))+s(1)+1,(1:s(1))+s(1)+1,s*2+1);
            obj.map(3,:) = intention(:);
            cos = mapRegion((1:s(1)),(1:s(1))+s(1)+1,s*2+1);
            obj.map(4,:) = cos(:);
        end
    end
    
end

