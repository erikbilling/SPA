% runId = obstacleCondition(runSet,timeRange)
%   Returns all rinIds for specified runSet, for which the obstacle appear
%   and disappar within specified time ranges.

function condId = obstacleCondition(runSet,runId,timeAppear,duration)
  if nargin < 4
    duration = [];
  end

  [appears, disappears] = obstacleEvents(runSet,runId);
  condId = [];
  if isempty(duration)
    for i = 1:length(runId)
      if any(appears(i)==timeAppear)
        condId(end+1) = runId(i);
      end
    end
  elseif isempty(timeAppear)
    for i = 1:length(runId)
      if any((disappears(i)-appears(i))==duration)
        condId(end+1) = runId(i);
      end
    end
  else
    for i = 1:length(runId)
      if any(appears(i)==timeAppear) && any((disappears(i)-appears(i))==duration)
        condId(end+1) = runId(i);
      end
    end
  end
end

