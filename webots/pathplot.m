
function h = pathplot(runSet,runId,map,computeOptimalPath)
  if nargin < 3
    map = 'mapz';
  end
  if nargin < 4
    computeOptimalPath = 0;
  end
  
  if ischar(map)
    maph = str2func(map);
    map = maph();
  end
  
  selectedPath = zeros(1,4);
  optimalDistances = {};
  percentDistance = ones(1,numel(runId))*100;
  times = gettimes(runSet,runId);
  completed = ~isnan(times);
  
  h = figure;
  for i = 1:numel(runId)
    log = loadlog(runSet,runId(i));
    selectedPathId = pathSelection(log);
    selectedPath(selectedPathId) = selectedPath(selectedPathId) + 1;
    
    [start, goal] = loginfo(runSet,runId(i));
    distances = getdistances(log);
    totalDistance = sum(distances);
    optimalDistance = [];
    for j = 1:length(optimalDistances)
      d = optimalDistances{j};
      if (d{1} == start) & (d{2} == goal)
        optimalDistance = d{3};
        break
      end
    end
    if isempty(optimalDistance) && computeOptimalPath
      optimalDistance = sum(getoptimaldistances(map,start,goal));
      fprintf('Optimal distance for run %d: %.2f\n',i,optimalDistance); 
      optimalDistances{end+1} = {start,goal,optimalDistance};
    end
    if computeOptimalPath && optimalDistance > 0
      percentDistance(i) = totalDistance/optimalDistance*100;
    end
    
    if numel(runId) > 1
      nx = ceil(sqrt(numel(runId)));
      ny = round(sqrt(numel(runId)));
      subplot(ny,nx,i);
    end
    
    imagesc(1-map);
    colormap('gray');
    hold on;
    axis off;
    axis image;
    x = log(:,4);
    y = log(:,2);
    line(x,y,'color',[.5,.5,.5],'linewidth',2);

    plot(start(2),start(1),'o','color','black','linewidth',2.5,'markersize',12);
    plot(goal(2),goal(1),'x','color','black','linewidth',2.5,'markersize',12);

    heading = -log(:,8) .* sign(log(:,6))+pi/2;
    step = 8;
    quiver(x(1:step:end),y(1:step:end),sin(heading(1:step:end)),-cos(heading(1:step:end)),0.6,'color','blue');

    if numel(runId) > 1
      title(sprintf('Run %d, dist: %.0f (%.0f%%), time: %d',runId(i), totalDistance, percentDistance(i), times(i)));
    else
      legend('Path','Start','Goal');
      title(sprintf('%s - Run %d, total distance: %.0f (%.0f%%), time: %d steps.',runSet,runId,totalDistance,percentDistance(i),times(i)));
    end
  end
  
  selectedPath = selectedPath ./ sum(selectedPath) * 100;
  
  fprintf('Average distance to optimal path: %.0f%% (+-%.0f%%).\n',mean(percentDistance(completed)),std(percentDistance(completed)));
  fprintf('Average time steps: %.0f (%.0f).\n',mean(times(completed)), std(times(completed)));
  fprintf('Paths - N: %.0f, S: %.0f, NS: %.0f, SN: %.0f\n',selectedPath(1),selectedPath(2),selectedPath(3),selectedPath(4));
  set(h,'position',[200 200 800 800]);
end