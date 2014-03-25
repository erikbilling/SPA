function [ output_args ] = fieldsurfaceplot(runSet,runId,t,fields,labels)

  [start, goal] = loginfo(runSet,runId);

%% Load field data 

  if nargin < 4
    load(sprintf('webots/epuck/runSets/%s/fields%d.mat',runSet,runId));
  end
  
%% Plot plan

  fieldh = figure;
  transitions = {'North','West','South','East'};
  for t = 1:numel(transitions)
    for i = 1:numel(labels)
      if strcmpi(labels{i},[transitions{t} '.motivation.recorder'])
        ploth = subaxis(2,2,t, 'Spacing', 0.06, 'Padding', 0, 'Margin', 0.07);   fieldData = fields{i};
        surface(fieldData(:,:,200),'linestyle','none');
        set(ploth,'clim',[-10 10]);
        axis off;
        title(transitions{t},'fontsize',18);
        hold on;
        line(start(2),start(1),-20,'marker','o','linewidth',3,'color','white','markersize',10);
        line(goal(2),goal(1),-20,'marker','x','linewidth',3,'color','white','markersize',10);
        view(0,-90);
      end
    end
  end
  set(fieldh,'position',[100 200 800 800]);


end

