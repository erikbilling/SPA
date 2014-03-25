% ps = pathSelection(runSet,[runId]) 
%   Returns the selected path in a z-maze with default start/goal
%   positions. Selected paths are classified into four categories:
%     1 - Noth path around the obstacle
%     2 - South path around the obstacle
%     3 - Noth path was initially selected, but later changed to south.
%     4 - South path was initially selected, but later changed to north.

function ps = pathSelection(runSet,runId)

  if ischar(runSet)
    ps = zeros(1,numel(runId));
    for i = 1:numel(runId)
      ps(i) = pathSelection(loadlog(runSet,runId(i)));
    end
  else
    tNorth = find(runSet(:,2)<30,1);
    tSouth = find(runSet(:,2)>50,1);

    if isempty(tNorth)
      ps = 2;
    elseif isempty(tSouth)
      ps = 1;
    elseif tSouth < tNorth
      ps = 4;
    else
      ps = 3;
    end
  end
end

