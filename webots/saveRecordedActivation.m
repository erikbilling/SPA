% saveRecordedActivation(sim)
%   Saves all fields in sim recorded using InputRecorder

function [fields, labels] = saveRecordedActivation(fileName,sim)

  fields = {};
  labels = {};
  for i = 1:sim.nElements
    if isa(sim.elements{i},'InputRecorder')
      fields{end+1} = sim.elements{i}.output;
      labels{end+1} = sim.elementLabels{i};
    end
  end

  save(fileName,'fields','labels');
  fprintf('Recorded fields saved to %s/%s.mat.\n',cd,fileName);
end

