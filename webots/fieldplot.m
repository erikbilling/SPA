function h = fieldplot(runSet,runId,m,plotTimes,arrowOffsets)
  transitions = {'north','east','south','west'};
  motivationOffset = [5 0 -5 0; 0 -5 0 5]; % [y;x]
    
  if nargin < 4
    plotTimes = [0 300 500 700];
  end
  if nargin < 5
    arrowOffsets = [
      5 -5; % (y, x)
      -4 5;
      -4 5;
      -4 -5;
    ];
  end
  r = load(sprintf('webots/epuck/runSets/%s/fields%d.mat',runSet,runId));
  log = loadlog(runSet,runId);
  
  N = length(plotTimes);
  x = zeros(0);
  y = zeros(0);
  
  function values = getTransitionValues(component,x,y)
    
    values = zeros(log(end,1),length(transitions));
    for d = 1:length(transitions)
      if strcmp('motivation',component)
        dx = x - motivationOffset(2,d);
        dy = y - motivationOffset(1,d);
      elseif nargin > 1
        dx = x;
        dy = y;
      end

      for f = 1:length(r.fields)
        if strcmp(r.labels{f},[transitions{d} '.' component '.recorder'])
          field = r.fields{f};
          if nargin > 1
            values(:,d) = field(dy,dx,1:size(values,1));
          else
            values(:,d) = max(max(field(:,:,1:size(values,1)),[],1),[],2);
          end
          [dots, parts] = regexp(r.labels{f},'\.','match','split');
        end
      end
    end
  end
  
  %% Motivation
  h(1) = figure('name',sprintf('%s: Motivation',runSet));
  h(2) = figure('name',sprintf('%s: Precondition',runSet));
  for i = 1:N
    t = plotTimes(i);    
    pos = log(log(:,1)==t,:);
    x(i) = round(pos(4));
    y(i) = round(pos(2));

    figure(h(1));
    subplot(N+1,1,i);
    motivation = getTransitionValues('motivation',x(i),y(i));    
    plot(motivation);
    title(sprintf('Motivation field (x = %d, y = %d, t = %d)',x(i),y(i),t));
    axis([0 log(end,1) -20 20]);
    
    figure(h(2));
    subplot(N+1,1,i);
    precondition = getTransitionValues('precondition',x(i),y(i));    
    plot(precondition);
    title(sprintf('Predcondition field (x = %d, y = %d, t = %d)',x(i),y(i),t));
    axis([0 log(end,1) -20 20]);
  end
  
  for ch = h
    figure(ch);
    set(h,'position',[100 100 1000 1000]);
    subplot(N+1,1,1);
    legend(transitions{:},'location','northwest');
  end
  
  %% Intention
  figure(h(1));     
  subplot(N+1,1,N+1);
  intention = getTransitionValues('intention');
  plot(intention);
  title('Intention field (max values)');
%   legend(transitions{:},'Location','WestOutside');
  axis([0 log(end,1) -15 15]);

  %% Cos
  figure(h(2));     
  subplot(N+1,1,N+1);
  cos = getTransitionValues('cos');
  plot(cos);
  title('COS field (max values)');
%   legend(transitions{:});
  axis([0 log(end,1) 0 15]);
  
  ph = pathplot(runSet,runId,m);
  line(x,y,'marker','x','markersize',10,'color','red','linewidth',2,'linestyle','none');
%   for i = 1:length(plotTimes)
%     cx = x(i) + arrowOffsets(i,2);
%     cy = y(i) + arrowOffsets(i,1);
%     if arrowOffsets(i,2) < 0
%       ax = x(i) - 2;
%       tx = x(i) + arrowOffsets(i,2) - 1;
%     else
%       ax = x(i) + 2;
%       tx = x(i) + arrowOffsets(i,2) + 1;
%     end
%     if arrowOffsets(i,1) < 0
%       ay = y(i) - 2;
%     else
%       ay = y(i) + 2;
%     end
%     arrow([cx cy],[ax ay]);
%     text(tx,cy,sprintf('t = %d',plotTimes(i)),'HorizontalAlignment',alignment,'fontsize',15);
%   end
end

