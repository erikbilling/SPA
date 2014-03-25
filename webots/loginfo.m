
function [start, goal] = loginfo(runSet,runId)

%% Log definitions

% Log files without specified noise have a map noise level of std 0.05.
% Log files with specified noise have a map noise level of std 1.0.

%% Return function

starts = load(sprintf('webots/epuck/runSets/%s/startPositions.mat',runSet),'-ascii');
goals = load(sprintf('webots/epuck/runSets/%s/goalPositions.mat',runSet),'-ascii');
runId(runId>size(starts,1)) = size(starts,1);
runId(runId>size(goals,1)) = size(goals,1);
start = starts(runId,[1 3]);
goal = goals(runId,:);

end