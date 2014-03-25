% [appears, disappears] = obstacleEvents(runSet,runId)
%   Returns time stamps for obstacle appearances and disappearances, or NaN
%   if the event did not occur. 

function [appears, disappears] = obstacleEvents(runSet,runId)

  f = fopen(sprintf('webots/epuck/runSets/%s/events.txt',runSet));
  appears = NaN(1,numel(runId));
  disappears = NaN(1,numel(runId));
  
  while f ~= -1 && ~feof(f)
    rid = fscanf(f,'%d',1);
    t = fscanf(f,'%d',1);
    obstacle = fscanf(f,'%s',1);
    x = fscanf(f,'%f',1);
    y = fscanf(f,'%f',1);
    z = fscanf(f,'%f',1);
    
    if rid
      idp = find(runId == rid);
      if idp
        appear = x > -1;
        if appear
          appears(idp) = t;
        else
          disappears(idp) = t;
        end
      end
    end
  end
  
end

