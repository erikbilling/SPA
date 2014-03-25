function resultsFullObstacle

%% Setup 
  runId = 1:240;
  collisions = [7    12    24    38    47    52    75   112   115 122   127   187   203   224   238];
  collisionFree = ones(size(runId));
  collisionFree(collisions) = 0;
  collisionFree = find(collisionFree);
  
  m = webotsMap('webots/epuck/worlds/e-puck-fieldsearch.wbt',[100 100]);
  m(:,[1:5 95:end]) = 1;
  m([1:5 95:end],:) = 1;
  m(6:23,35:45) = 0.5;
  
  
%% Obstacle vs path length 

  obstacleplot3d('full-lownoise',collisionFree);
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
  
%% Field plot 11
  fieldplot('full-lownoise',11,m,[0 500 850 1250]);

%% Path plot 11
  pathplot('full-lownoise',11,m);

%% Load field data 

  run11 = load('webots/epuck/runSets/full-lownoise/fields11.mat');
  
%% Plot plan

  fieldsurfaceplot('full-lownoise',11,210,run11.fields,run11.labels);
  colorbar('eastoutside','position',[0.94 0.07 0.03 0.855],'fontsize',14);
end