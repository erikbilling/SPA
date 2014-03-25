% obstacleplot(runSet,runId)
%   Plots different path statistics as a function of obstacle appearance
%   time and duration. 

function h = obstacleplot(runSet,runId)

  [appears, disappears] = obstacleEvents(runSet,runId);
  a500 = appears < 500;
  duration = disappears - appears;
  distances = zeros(1,numel(runId));
  selectedPath = zeros(1,numel(runId));
  
  for i = 1:numel(runId)
    log = loadlog(runSet,runId(i));
    selectedPath(i) = pathSelection(log);
    distances(i) = sum(getdistances(log));
  end
  
  h = figure;
  colors = {'green','blue','red','magenta'};
  
  subplot(2,1,1);
  title(sprintf('%s (N=green,S=blue,NS=red,SN=magenta)',runSet));
  hold on;
  for i=1:4
    if any(selectedPath==i)
      plot(duration(selectedPath==i &  a500),distances(selectedPath==i &  a500),'marker','x','linestyle','none','color',colors{i},'linewidth',2);
      plot(duration(selectedPath==i & ~a500),distances(selectedPath==i & ~a500),'marker','o','linestyle','none','color',colors{i},'linewidth',2);
    end
  end
  hold off;
  xlabel('Obstacle duration (time steps)');
  ylabel('Path length (time steps)');
  
  subplot(2,1,2);
  hold on;
  for i=1:4
    if any(selectedPath==i)
      plot(appears(selectedPath==i &  a500),distances(selectedPath==i &  a500),'marker','x','linestyle','none','color',colors{i},'linewidth',2);
      plot(appears(selectedPath==i & ~a500),distances(selectedPath==i & ~a500),'marker','o','linestyle','none','color',colors{i},'linewidth',2);
    end
  end
  hold off;
  xlabel('Obstacle apperance (time steps)');
  ylabel('Path length (time steps)');
end

