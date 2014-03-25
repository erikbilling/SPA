% Returns the distance to goal for the last sample in each log file for
% specified run set. 

function distances = finalDistances(runSet,runId)
  runDir = ['webots/epuck/runSets/' runSet];
  
  if exist([runDir '/goalPositions.mat'],'file')
    goals = load('-ascii',[runDir '/goalPositions.mat']);
    if nargin < 2
      runId = 1:size(goals,1);
    end
    distances = ones(numel(runId),1);
    for i = runId
      runFile = sprintf('%s/run%d.mat',runDir,i);
      if exist(runFile,'file')
        run = load('-ascii',runFile);
        dyx = run(end,[2 4]) - goals(i,:);
        distances(i) = sqrt(sum(dyx.*dyx));
      end
    end
  else
    distances = [];
  end
  
end

