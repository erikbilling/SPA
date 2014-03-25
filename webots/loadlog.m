function map = loadlog(runSet,runId)
  map = load(sprintf('webots/epuck/runSets/%s/run%d.mat',runSet,runId),'-ascii');
end

