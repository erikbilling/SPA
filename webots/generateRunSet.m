function [startPositions,goalPositions] = generateRunSet(setName)

  % Z-map
  map = ones(9);
  map(3,3:5) = 0;
  map(4:6,5) = 0;
  map(7,5:7) = 0;
  
  start = [5	0	5	0	1	0	0];
  goal = [40 40];
  
  startPositions = repmat(start,sum(map(:)),1);
  
  i = 1;
  for x = 1:size(map,2)
    for y = 1:size(map,1)
      if map(y,x)
        startPositions(i,3) = x * 10;
        startPositions(i,1) = y * 10;
        i = i+1;
      end
    end
  end
  
  goalPositions = repmat(goal,sum(map(:)),1);

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
    fprintf(sp,'%d\t%d\t%d\t%d\t%d\t%d\t%d\n',srow(1),srow(2),srow(3),srow(4),srow(5),srow(6),srow(7));
    fprintf(gp,'%d\t%d\n',grow(1),grow(2));
  end
  fclose(sp);
  fclose(gp);
end


