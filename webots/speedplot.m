function speedplot(runSet,runId)
  colors = {'green','blue','red','magenta'};

  if iscell(runSet)
    speedplot(runSet{1},runId);
    hold on;
    for i = 2:length(runSet)
      log = loadlog(runSet{i},runId);
      dists = getdistances(log);
      plot(1:2:(numel(dists)*2),dists,colors{pathSelection(log)},'linewidth',2,'linestyle','--');
    end
    hold off;
  else
    [appears, disappears] = obstacleEvents(runSet,runId);
    patch([appears appears disappears disappears], [1 0 0 1], [.7 .7 .7], 'edgecolor', [.5 .5 .5]);
    hold on;

    log = loadlog(runSet,runId);
    dists = getdistances(log);
    plot(1:2:(numel(dists)*2),dists,colors{pathSelection(log)},'linewidth',2);
    hold off
  end
end

