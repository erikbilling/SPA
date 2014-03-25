% ElementaryBehavior 
%
% Constructor call:
% ElementaryBehavior(sim, label, size, tau, h, beta, inputs)
%
% Author: Erik Billing (erik.billing@his.se). 

classdef ElementaryBehavior < Collection
  
    properties (Constant)
        fields = {'motivation','precondition','intention','cos'};
    end
    
    properties
        % parameters
        sim = [];
        size = [1, 100];
        tau = struct('motivation',10,'precondition',10,'intention',10,'cos',20);
        h = -5;
        beta = 4;
        sigma = 2;
        inputs = {};
        connections = struct;
        
        % accessible structures
        precondition = [];
        motivation = [];
        intention = [];
        cos = [];
        nFields = 0;
    end
    
    methods
        % constructor
        function obj = ElementaryBehavior(sim, label, size, tau, h, beta, sigma, inputs, connections)
          obj.sim = sim;
          obj.label = label;

          if nargin >= 3
            obj.size = size;
          end
          if nargin >= 4
            obj.tau = tau;
          end
          if nargin >= 5
            obj.h = h;
          end
          if nargin >= 6
            obj.beta = beta;
          end
          if nargin >= 7
            obj.sigma = sigma;
          end
          if nargin >= 8
            obj.inputs = inputs;
          end

          if numel(obj.size) == 1
            obj.size = [1, obj.size];
          end

          obj = obj.init;
          if nargin > 8
            obj.connections = obj.defaultConnections(connections);
          else
            obj.connections = obj.defaultConnections;
          end
        end
        
        function c = defaultConnections(obj,connections)
            % Returns a struct hierarchy representing connections:
            % c.from.to.amplitude = value
            % c.from.to.shift = [y x]
            %
            % connections is a cell matrix that overrides default values:
            %   = {from1, to1, amplitude, from2, to2, {'shift', [y x]}}
            
            c.motivation.precondition.amplitude = 12;
            c.motivation.intention.amplitude = 10;
            c.precondition.intention.amplitude = -10;
            c.intention.cos.amplitude = 5;
            c.cos.intention.amplitude = -5;
%             c.cos.motivation.amplitude = -10;
            
            if nargin > 1
                for i = 1:3:length(connections)
                    v = connections{i+2};
                    if iscell(v)
                        for j=1:2:length(v)
                            c.(connections{i}).(connections{i+1}).(v{j}) = v{j+1};
                        end
                    else
                        c.(connections{i}).(connections{i+1}).amplitude = v;
                    end
                end
            end
            
            for i = 1:length(obj.fields)                
                if isfield(c,obj.fields{i})
                    for j = 1:length(obj.fields)
                        if isfield(c.(obj.fields{i}),obj.fields{j})
                            con = c.(obj.fields{i}).(obj.fields{j});
                            if ~isfield(con,'sigma')
                                con.sigma = obj.sigma;
                            end
                            if isfield(con,'shift')
                                obj.createShiftedConnection(obj.fields{i},obj.fields{j},con.sigma,con.amplitude,con.shift);
                            else
                                obj.createStandardConnection(obj.fields{i},obj.fields{j},con.sigma,con.amplitude);
                            end
                        end
                    end
                end
            end
        end
       
        function obj = createStandardConnection(obj, from, to, sigma, amplitude) 
            if obj.size(1)==1
                obj.sim.addElement(GaussKernel1D([obj.label '.' from ' -> ' obj.label '.' to], obj.size, sigma, amplitude, true, true), [obj.label '.' from], 'output', [obj.label '.' to]);
            else
                obj.sim.addElement(GaussKernel2D([obj.label '.' from ' -> ' obj.label '.' to], obj.size, sigma, sigma, amplitude), [obj.label '.' from], 'output', [obj.label '.' to]);
            end
        end
        
        function obj = createShiftedConnection(obj, from, to, sigma, amplitude, shift)
            shiftLabel = [obj.label '.' from '.shift'];
            if ~obj.sim.isElement(shiftLabel)
                obj.sim.addElement(ShiftInput(shiftLabel,obj.size,shift),[obj.label '.' from]);
            end
            
            obj.sim.addElement(GaussKernel2D([obj.label '.' from ' -> ' obj.label '.' to], obj.size, sigma, sigma, amplitude), shiftLabel, 'output', [obj.label '.' to]);
        end
        
        function obj = lateralInteraction(obj, field, sigmaExc, amplitudeExc, sigmaInh, amplitudeInh, amplitudeGlobal)
            if nargin < 3
                sigmaExc = 2;
            end
            if nargin < 4
                amplitudeExc = 5;
            end
            if nargin < 5
                sigmaInh = 0;
            end
            if nargin < 6
                amplitudeInh = 0;
            end
            if nargin < 7
                amplitudeGlobal = 0;
            end
            if obj.size(1)==1
                obj.sim.addElement(LateralInteractions1D([obj.label '.' field ' -> ' obj.label '.' field], obj.size, sigmaExc, amplitudeExc, sigmaInh, amplitudeInh, amplitudeGlobal, true, true), [obj.label '.' field], 'output', [obj.label '.' field]);
            else
                if amplitudeExc > 0
                    obj.sim.addElement(GaussKernel2D([obj.label '.' field ' e> ' obj.label '.' field], obj.size, sigmaExc, sigmaExc, amplitudeExc), [obj.label '.' field], 'output', [obj.label '.' field]);
                end
                if amplitudeInh > 0
                    obj.sim.addElement(GaussKernel2D([obj.label '.' field ' i> ' obj.label '.' field], obj.size, sigmaInh, sigmaInh, -amplitudeInh), [obj.label '.' field], 'output', [obj.label '.' field]);
                end
                if amplitudeGlobal ~= 0
                    obj.sim.addElement(SumDimension([obj.label '.' field ' g> ' obj.label '.' field], [1 2], amplitudeGlobal), [obj.label '.' field], 'output', [obj.label '.' field]);
                end
            end
        end
        
        function obj = addNoise(obj, field)
            obj.sim.addElement(NormalNoise([obj.label '.' field '.noise'], obj.size, 1),{},{},[obj.label '.' field]);
%             if obj.size(1)==1
%                 obj.sim.addElement(GaussKernel1D([obj.label '.' field '.noise.kernel'], obj.size, 0, 1, true, true), [obj.label '.' field '.noise'], 'output', [obj.label '.' field]);
%             else
%                 obj.sim.addElement(GaussKernel2D([obj.label '.' field '.noise.kernel'], obj.size, 0, 0, 1, true, true), [obj.label '.' field '.noise'], 'output', [obj.label '.' field]);
%             end
        end

        % intialization
        function obj = init(obj)            
            for i = 1:length(obj.fields)
                obj = obj.initField(obj.fields{i});
            end
                        
            % Lateral interaction
            obj.lateralInteraction('motivation',2,7,4,2);
%             obj.lateralInteraction('motivation',2,4,4,-2);
%             obj.lateralInteraction('precondition',2,4);
            obj.lateralInteraction('precondition',2,4,4,2);
            obj.lateralInteraction('intention',2,9,0,0,0);
            obj.lateralInteraction('cos',2,2,4,2);
            
            % noise
            obj.addNoise('precondition');
            obj.addNoise('motivation');
            obj.addNoise('intention');
            obj.addNoise('cos');
        end
        
        function obj = initField(obj,field)
          if isstruct(obj.tau)
            tau = obj.tau.(field);
          else
            tau = obj.tau;
          end
          obj.(field) = NeuralField([obj.label '.' field],obj.size,tau,obj.h,obj.beta);

          params = {};
          for i = 1:2:length(obj.inputs)
              if strcmp(field,obj.inputs{i})
                  params = [params obj.inputs(i+1)];
              end
          end
          obj.sim.addElement(obj.(field),params{:});
          obj.nFields = obj.nFields+1;
        end
        
        function obj = connectGaussian(obj,eb,inPos,outPos,inSize,outSize,amplitude)
            if nargin < 7
                amplitude = 1;
            end
            revName = [eb.label '.precondition w> ' obj.label '.motivation'];
            fowName = [obj.label '.cos w> ' eb.label '.precondition'];
            myRange = 1:obj.size(2);
            ebRange = 1:eb.size(2);
            revW = gauss2d(myRange,ebRange,inPos,outPos,inSize,outSize)'*amplitude;
            fowW = gauss2d(myRange,ebRange,inPos,outPos,inSize+1,outSize+1)*amplitude*-1;
            try
                revCon = obj.sim.getElement(revName);
                fowCon = obj.sim.getElement(fowName);
                revCon.weights = revCon.weights + revW;
                fowCon.weights = fowCon.weights + fowW;
            catch
                revCon = WeightMatrix(revName,revW);
                obj.sim.addElement(revCon,[eb.label '.precondition'],'output',[obj.label '.motivation']);
                fowCon = WeightMatrix(fowName,fowW);
                obj.sim.addElement(fowCon,[obj.label '.cos'],'output',[eb.label '.precondition']);
            end
        end
    end
    
end


