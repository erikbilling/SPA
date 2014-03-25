% resultsZ
%   Results for 100 runs in the Z-maze, with random start and goal
%   positions. 

function resultsZ

%% Setup 
  runId = 1:100;
  
  m = webotsMap('webots/epuck/worlds/e-puck-fieldsearch.wbt',[100 100]);
  m(:,[1:5 95:end]) = 1;
  m([1:5 95:end],:) = 1;

%% Final distances

  goalReachedLowNoise = finalDistances('rand-z-lownoise') < 7;
  fprintf('Proportion goal reached (low noise): %.1f%%\n',sum(goalReachedLowNoise)/length(goalReachedLowNoise)*100);
  goalReachedHighNoise = finalDistances('rand-z-highnoise') < 7;
  fprintf('Proportion goal reached (high noise): %.1f%%\n',sum(goalReachedHighNoise)/length(goalReachedHighNoise)*100);
    
%% Global low noise
  fprintf('** Results for random start/goal positions in z-maze, low noise **\n');
  pathplot('rand-z-lownoise',find(goalReachedLowNoise),m,true);

% Global high noise
  fprintf('** Results for random start/goal positions in z-maze, high noise **\n');
  pathplot('rand-z-highnoise',find(goalReachedHighNoise),m,true);

%% Field plot
  fieldplot('noobst-lownoise',74,m);
  
%% T-test noise effect
  load optimalDistances; % Save to avoid recaluclation of optimal paths
  [H, P] = testPathLengths(m,'rand-z-highnoise','rand-z-lownoise',1:100,1:100,optimalDistancesZ);
  
%% T-test noise effect 3C
  [H, P] = testPathLengths(m,'noobst-highnoise','noobst-lownoise',5:60);
  
end