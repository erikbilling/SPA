
classdef EBMove < ElementaryBehavior
        
    properties
    end
    
    methods
      function obj=EBMove(sim, label, size, tau, h, beta, sigma, inputs, connections)
        args = {sim, label, size, tau, h, beta};
        if nargin >=7
          args{7} = sigma;
        end
        if nargin >=8
          args{8} = inputs; 
        end
        if nargin >=9
          args{9} = connections;
        end
        obj = obj@ElementaryBehavior(args{:});
        
        obj.setupLog(sim);
      end
        
      function obj=setupLog(obj,sim)
        global recordActivation;
        
        if ~isempty(recordActivation)
          for i = 1:length(obj.fields)
            field = [obj.label '.' obj.fields{i}];
            sim.addElement(InputRecorder([field '.recorder'],obj.size,recordActivation),field,'activation');
          end
        end
      end
      
      function obj=createLateralConnections(obj,shift,amplitude)
        if nargin < 2
          shift = [0 0];
        end
        if nargin < 3
          amplitude = 5;
        end
        obj.createInterConnections(obj,shift,amplitude);
      end

      function obj=createInterConnections(obj,targetEb,shift,amplitude)
        if nargin < 4
          amplitude = 4.5;
        end
        if nargin < 3
          shift = [0 0];
        end
        obj.sim.addElement(ShiftInput([targetEb.label '.precondition -> ' obj.label '.motivation'],obj.size,shift,amplitude), ...
          [targetEb.label '.precondition'], 'output', [obj.label '.motivation']);
      end

      function obj=createBlockingConnections(obj,targetEb,shift,amplitude)
          if nargin < 4
              amplitude = -10;
          end

          obj.sim.addElement(ShiftInput([obj.label '.precondition -> ' targetEb.label '.motivation'], obj.size, shift.*0, amplitude), ...
            [obj.label '.precondition'], 'output', [targetEb.label '.motivation']);
      end
        
    end
    
end

