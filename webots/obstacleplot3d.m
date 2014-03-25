% h = lengthplot(runSet,runId)
%   Plots the path length of specified runs in a 3d bar chart. X-axis
%   represents obstacle apperance time and Y axis obstacle duration. 

function h = obstacleplot3d(runSet,runId)

  barSize = 20;
  appearMax = 800;
  durationMax = 500;
  z = NaN(durationMax/barSize,appearMax/barSize);
  colors = zeros(durationMax/barSize,appearMax/barSize);
  
  [appears, disappears] = obstacleEvents(runSet,runId);
  duration = disappears - appears;
  selectedPath = zeros(1,numel(runId));
  for i = 1:numel(runId)
    log = loadlog(runSet,runId(i));
    selectedPath(i) = pathSelection(log);
    distances(i) = sum(getdistances(log));
  
    x = ceil(appears(i)/barSize);
    y = ceil(duration(i)/barSize);
    if isnan(z(y,x))
      z(y,x) = distances(i);
      colors(y,x) = selectedPath(i);
    else
      fprintf('Warning: information lost: run %d.\n',i);
    end
  end
  
  h = bar3(z);
  colormap([.5 .5 .5; 0 1 0; 0 0 1; 1 0 0]);
  for x = 1:size(colors,2)
    c = get(h(x),'cdata');
    step = size(c,1)/durationMax*barSize;
    for y = 1:size(colors,1)
      c(((y-1)*step+1):(y*step),:) = colors(y,x);
    end
    set(h(x),'cdata',c,'facecolor','interp');
  end
  
  xlabels = cell(1,20); 
  ylabels = cell(1,20);
  for i = 1:20
    xlabels{i} = num2str(i*barSize*5);
    ylabels{i} = num2str((i-1)*barSize*5);
  end
  
  set(gca,'xticklabel',xlabels);
  set(gca,'yticklabel',ylabels);
  
  xlabel('Obstacle apperance time');
  ylabel('Obstacle duration');
  
  set(gca,'xlim',[0 40])
  set(gca,'ylim',[0 25])
end

