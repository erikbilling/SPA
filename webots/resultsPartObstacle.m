function resultsFullObstacle

%% Setup 
  runId = 1:240;
  collisions = find(obstacleCollisions('part-lownoise',1:240,'part',8));
  collisionFree = ones(size(runId));
  collisionFree(collisions) = 0;
  collisionFree = find(collisionFree);
  
  m = webotsMap('webots/epuck/worlds/e-puck-fieldsearch.wbt',[100 100]);
  m(:,[1:5 95:end]) = 1;
  m([1:5 95:end],:) = 1;
  m(6:23,35:45) = 0.5;
  
  
%% Obstacle vs path length 

  obstacleplot3d('part-lownoise',collisionFree);
%   obstacleplot('full-lownoise',run);
  
%% Complete path plot

  pathplot2('full-highnoise',1:120,m,false);
  pathplot2('full-lownoise',1:120,m,false);
  
%% Global
  fprintf('** Results for fully obtrucing obstacle, high noise **\n');
  fprintf('%d runs were removed du to obstacle collision.\n',length(collisions));
  pathplot('full-highnoise',collisionFree,m,true);
  
%% Case 31
  run = obstacleCondition('full-highnoise',collisionFree,[],1:49);
  fprintf('\nObstacle persisted for less than 50 time steps (%d runs):\n',length(run));
  pathplot('full-highnoise',run,m,true);
  
%% Case 32
  run = obstacleCondition('full-highnoise',collisionFree,1:129,50:500);
  fprintf('\nObstacle appear before 130 and remains for at least 50 steps (%d runs):\n',length(run));
  pathplot('full-highnoise',run,m,true);

%% Case 33
  run = obstacleCondition('full-highnoise',collisionFree,501:700);
  fprintf('\nObstacle appear after time step 500 (%d runs):\n',length(run));
  pathplot('full-highnoise',run,m,true);
  
%% Case 34
  run = obstacleCondition('full-highnoise',collisionFree,130:500,50:500);
  fprintf('\nObstacle appear within 130 < t < 500 and remains for at least 50 time steps (%d runs):\n',length(run));
  pathplot('full-highnoise',run,m,true);
  
end