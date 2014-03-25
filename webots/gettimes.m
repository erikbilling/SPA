% Returns the number of time steps required for the robot to reach the goal

function times = gettimes(runSet,runId)
  goalRadius = 7;

  [start, goal] = loginfo(runSet,runId);
  distances = getdistances(runSet,runId,goal);
  
  times = NaN(length(runId),1);
  for i = 1:length(runId)
    log = loadlog(runSet,runId(i));
    t = find(distances(:,i)<goalRadius,1);
    if ~isempty(t) 
      times(i) = log(t,1);
    end
  end


end

