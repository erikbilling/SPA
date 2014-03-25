% If goal is specified, returns the distance to goal for each time step in
% log file. If goal is omitted, the translation distance between each
% loged position is returned. 

function distances = getdistances(runSet,runId,goal)
  if nargin < 2 || numel(runId) < 2
    if ischar(runSet)
      log = loadlog(runSet,runId);
    else
      log = runSet;
    end

    if nargin < 3
      translation = diff(log(:,[2 4]));
    else
      cord = log(:,[2 4]);
      translation = cord - repmat(goal,size(cord,1),1);
    end
    distances = sqrt(translation(:,1).*translation(:,1)+translation(:,2).*translation(:,2));
  else
    distances = zeros(1,numel(runId));
    for i = 1:numel(runId)
      if nargin >= 3
        d = getdistances(runSet,runId(i),goal(i,:));
      else
        d = getdistances(runSet,runId(i));
      end
      distances(end+1:length(d),:) = Inf;
      distances(1:length(d),i) = d;
    end
  end
end

