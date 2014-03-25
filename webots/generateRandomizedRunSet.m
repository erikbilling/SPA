function [startPositions,goalPositions] = generateRandomizedRunSet(setName,map,runCount,padding)
  
  if nargin < 4
    padding = [3 3];
  end
  
  xsize = size(map,2);
  ysize = size(map,1);
  startPositions = repmat([5	0	5	0	1	0	0],runCount,1);
  goalPositions = repmat([40 40],runCount,1);
  epuckRange = -4:4;
  
  
  i = 1;
  setGoal = 0;
  for j = 1:runCount*100
    x = ceil(rand*xsize);
    y = ceil(rand*ysize);
    m = map;
    if min(epuckRange+x) <= padding(2) || min(epuckRange+y) <= padding(1)
      continue;
    elseif max(epuckRange+x) > xsize-padding(2) || max(epuckRange+y) > ysize-padding(1)
      continue;
    end
    
    obstacles = find(m(epuckRange+y,epuckRange+x),1);
    if isempty(obstacles)
      if setGoal
        goalPositions(i,:) = [y x];
        i = i+1;
        if i > runCount
          break;
        end
      else
        startPositions(i,[1 3]) = [y x];
      end
      setGoal = mod(setGoal+1,2);
    end
  end
  
  if i <= runCount
    error('Unable to find randomized positions for all runs');
  end
  
  startPositions(:,7) = rand(runCount,1)*2*pi;
  
  
  %% Saving to files
  setDir = sprintf('webots/epuck/runSets/%s',setName);
  if ~isdir(setDir)
    mkdir(setDir);
  end
  sp = fopen([setDir '/startPositions.mat'],'w');
  gp = fopen([setDir '/goalPositions.mat'],'w');
  
  for row = 1:size(startPositions,1)
    srow = startPositions(row,:);
    grow = goalPositions(row,:);
    fprintf(sp,'%d\t%d\t%d\t%d\t%d\t%d\t%.3f\n',srow(1),srow(2),srow(3),srow(4),srow(5),srow(6),srow(7));
    fprintf(gp,'%d\t%d\n',grow(1),grow(2));
  end
  fclose(sp);
  fclose(gp);
end



