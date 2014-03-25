% runId = obstacleCollisions(runSet,distanceThreshold,obstaclePosition)

function collisionId = obstacleCollisions(runSet,runId,obstacleType,distanceThreshold)

  if nargin < 4
    distanceThreshold = 4;
  end

  if strcmp(obstacleType,'full')
    obstaclePositions = [10 40; 15 40; 20 40];
  else
    obstaclePositions = [20 30; 20 35; 20 40; 20 45; 20 50];
  end

  [appears, disappears] = obstacleEvents(runSet,runId);
  
  collisionId = zeros(1,numel(runId));
  for run = runId
    if appears(run)
      log = loadlog(runSet,run);
      filter = log(:,1)>appears(run);
      if disappears(run)
        filter = filter & log(:,1)<disappears(run);
      end
      if any(filter)
        olog = log(filter, :);
        for obstacle = 1:size(obstaclePositions,1)
          odists = getdistances(olog,[],obstaclePositions(obstacle,:));
          if min(odists) <= distanceThreshold
            collisionId(run) = 1;
          end
        end
      end
    end
  end
  
  
end