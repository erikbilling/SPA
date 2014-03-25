function h = pathplotAll()

%% Setup
  collisionFreeFullLN = find(1-obstacleCollisions('full-lownoise',1:100,'full',8));
  collisionFreePartLN = find(1-obstacleCollisions('part-lownoise',1:100,'part',8));
  collisionFreeFullHN = find(1-obstacleCollisions('full-highnoise',1:100,'full',8));
  collisionFreePartHN = find(1-obstacleCollisions('part-highnoise',1:100,'part',8));
  
  m = webotsMap('webots/epuck/worlds/e-puck-fieldsearch.wbt',[100 100]);
  m(:,[1:5 95:end]) = 1;
  m([1:5 95:end],:) = 1;
  mapFull = m;
  mapFull(6:23,35:45) = 0.5;
  mapPart = m;
  mapPart(15:25,25:55) = 0.5;
  
%% Path Plot 
  h = figure;
  map = {mapPart,mapFull,mapPart,mapFull};
  runSet = {'part-highnoise','full-highnoise','part-lownoise','full-lownoise'};
  runId = {collisionFreePartHN,collisionFreeFullHN,collisionFreePartLN,collisionFreeFullLN};
  for i=1:4
    subaxis(2,2,i, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
    imagesc(1-map{i});
    colormap('gray');
    hold on;
    axis off;
    axis tight;
    pathplot2(runSet{i},runId{i},m,false,{},h);
  end
  
end

