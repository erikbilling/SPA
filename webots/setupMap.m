function [ map ] = setupMap(mapSize,padding,noise)
  
  if nargin < 2
    padding = [5 5];
  end
  if nargin < 3
    noise = 0.05;
    
  end
  
  map = EBMap('map',zeros(mapSize),padding,noise);
  
%   map.matrix = map.matrix + webotsMap('../../worlds/e-puck-fieldsearch.wbt',mapSize);
  
  % Old fieldsearch map
%   map.matrix(35:75,45:55) = 1;
%   map.matrix(65:75,55:75) = 1;

%% Z-map

%   changeTime = 2;
%   changeTime = 70;
%   changeTime = 170;
%   changeTime = 270;
%   changeTime = 2000;

%   map.matrix(25:34,25:54) = 1;
%   map.matrix(35:64,45:54) = 1;
%   map.matrix(65:74,45:74) = 1;
  
%% Blocking obstacle
%   map.addChange(changeTime,1:24,35:44,1);

%% Minor obstacle, medium

%   map.addChange(changeTime,20:24,25:55,1);
%   map.addChange(changeTime,30:35,25:55,0);

%% Z-shift
  
%   map.addChange(changeTime,20:24,25:55,1);
%   map.addChange(changeTime,60:65,55:75,1);
%   map.addChange(changeTime,30:35,25:44,0);
%   map.addChange(changeTime,70:75,45:75,0);

%% Z-shift large
%   
%   map.addChange(changeTime,15:24,25:55,1);
%   map.addChange(changeTime,55:64,55:75,1);
%   map.addChange(changeTime,25:35,25:44,0);
%   map.addChange(changeTime,65:75,45:75,0);
  
%% Large maze
  map.matrix = map.matrix + webotsMap('../../worlds/e-puck-fieldsearch-large.wbt',mapSize);
  
end

