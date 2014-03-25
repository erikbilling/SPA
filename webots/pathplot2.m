
function h = pathplot2(runSet,runId,map,computeOptimalPath,plotProperties,h)
  if nargin < 3
    map = 'mapz';
  end
  if nargin < 4
    computeOptimalPath = 0;
  end
  if nargin < 5
    plotProperties = {};
  end
  
  if ischar(map)
    maph = str2func(map);
    map = maph();
  end
  
  selectedPath = zeros(1,4);
  times = gettimes(runSet,runId);
  completed = ~isnan(times);
  
  if nargin < 6
    h = figure('name',runSet);
    imagesc(1-map);
    colormap('gray');
    hold on;
    axis off;
  end
  
  [start, goal] = loginfo(runSet,runId(1));
  line(start(2),start(1),'marker','o','color','black','linewidth',2,'markersize',12);
  line(goal(2),goal(1),'marker','x','color','black','linewidth',2,'markersize',12);

  if computeOptimalPath
    optimalPath = bestPath(map,start([2 1]),goal([2 1]),4);
    optimalDistance = sum(diff(optimalPath(:,1)));
    percentDistance = zeros(1,numel(runId));

    line(optimalPath(:,2),optimalPath(:,3),'color','black','linewidth',2,'linestyle','--');
  end
  
  for i = 1:numel(runId)
    log = loadlog(runSet,runId(i));
    selectedPathId = pathSelection(log);
    selectedPath(selectedPathId) = selectedPath(selectedPathId) + 1;
    
    distances = getdistances(log);
    totalDistance = sum(distances);
    
    if computeOptimalPath && optimalDistance > 0
      percentDistance(i) = totalDistance/optimalDistance*100;
    end
    

    x = log(:,4);
    y = log(:,2);
    colors = {'green','blue','red','magenta'};
    patchline(x,y,'edgecolor',colors{selectedPathId},'linewidth',4,'edgealpha',.08);
    
  end

  selectedPath = selectedPath ./ sum(selectedPath) * 100;
  
  if exist('percentDistance')
    fprintf('Average distance to optimal path: %.0f%% (+-%.0f%%).\n',mean(percentDistance(completed)),std(percentDistance(completed)));
  end
  fprintf('Average time steps: %.0f (%.0f).\n',mean(times(completed)), std(times(completed)));
  fprintf('Paths - N: %.0f, S: %.0f, NS: %.0f, SN: %.0f\n',selectedPath(1),selectedPath(2),selectedPath(3),selectedPath(4));
  set(h,'position',[200 200 800 800]);
end