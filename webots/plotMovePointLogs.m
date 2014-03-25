% Creates line plots over time, for all recorded fields in the simulation.

function plotMovePointLogs(sim,yPoints,xPoints)

  inputRecorders = {};
  recorderLabels = {};
  
  for i = 1:length(sim.elements)
    el = sim.elements{i};
    if isa(el,'InputRecorder')
      inputRecorders{end+1} = el;
      label = strrep(el.label,'.recorder','');
      label = strrep(label,'.motivation',' M');
      label = strrep(label,'.precondition',' P');
      label = strrep(label,'.intention',' I');
      label = strrep(label,'.cos',' C');
      label(1) = upper(label(1));
      recorderLabels{end+1} = label;
    end
  end
  
  if ~isempty(inputRecorders)
    h = figure;
    
    for p = 1:length(yPoints)      
      data = zeros(size(inputRecorders{1}.output,3),length(inputRecorders));

      for r = 1:4
        subplot(length(yPoints)*4,1,p*4+r-4);
        for i = 1:4:length(inputRecorders)
          ir = inputRecorders{i+r-1};
          data(:,i) = ir.output(yPoints(p),xPoints(p),:);
        end
        plot(data);
        legend(recorderLabels(0+r:4:end));
        axis([0,size(data,1),-15,15]);
      end
    end
  end
end

