function resultsLarge

%% Setup 
  runId = 1:100;
  
  m = webotsMap('webots/epuck/worlds/e-puck-fieldsearch-large.wbt',[210 210]);
  m(:,[1:5 205:end]) = 1;
  m([1:5 205:end],:) = 1;

%% Final distances

  goalReachedLowNoise = finalDistances('rand-large-lownoise') < 7;
  fprintf('Proportion goal reached (low noise): %.1f%%\n',sum(goalReachedLowNoise)/length(goalReachedLowNoise)*100);
  goalReachedHighNoise = finalDistances('rand-large-highnoise') < 7;
  fprintf('Proportion goal reached (high noise): %.1f%%\n',sum(goalReachedHighNoise)/length(goalReachedHighNoise)*100);
    
%% Complete path plot

  pathPlotRuns = [2 4 8 62 66 100];
  h3 = pathplot3('rand-large-highnoise',pathPlotRuns,m,{'marker','s'});
  pathplot3('rand-large-lownoise',pathPlotRuns,m,{'marker','d','markersize',6},h3);
    
%% Complete path plot, failed runs

  failedRuns = find((goalReachedHighNoise & goalReachedLowNoise) == 0);
  h3 = pathplot3('rand-large-highnoise',failedRuns,m,{'marker','s'});
  pathplot3('rand-large-lownoise',failedRuns,m,{'marker','d','markersize',6},h3);
  
%% Global low noise
  fprintf('** Results for random start/goal positions in large maze, low noise **\n');
  pathplot('rand-large-lownoise',find(goalReachedLowNoise),m,true);

% Global high noise
  fprintf('** Results for random start/goal positions in large maze, high noise **\n');
  pathplot('rand-large-highnoise',find(goalReachedHighNoise),m,true);

%% T-test noise

  load optimalDistances; % Save to avoid recaluclation of optimal paths
  [H, P] = testPathLengths(m,'rand-large-highnoise','rand-large-lownoise',1:100,1:100,optimalDistancesLarge);
end