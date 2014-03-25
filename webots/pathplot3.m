
function h = pathplot3(runSet,runId,map,marker,h)
  if nargin < 3
    map = 'mapz';
  end
  if nargin < 4
    marker = {};
  end
  
  if ischar(map)
    maph = str2func(map);
    map = maph();
  end
  
  selectedPath = zeros(1,4);
  times = gettimes(runSet,runId);
  completed = ~isnan(times);
  
  if nargin < 5
    h = figure('name',runSet);
    subaxis(1,1,1, 'Spacing', 0.03, 'Padding', 0, 'Margin', 0);
    imagesc(1-map);
    colormap('gray');
    hold on;
    set(h,'position',[200 200 800 800]);
    axis off;
  end

  colors = {'magenta', 'green','yellow','blue','cyan','red'};
  
  for i = 1:numel(runId)
    log = loadlog(runSet,runId(i));
    [start, goal] = loginfo(runSet,runId(i));
    plot(start(2),start(1),'o','color','black','linewidth',2.5,'markersize',12);
    plot(goal(2),goal(1),'x','color','black','linewidth',2.5,'markersize',12);
    
    x = log(:,4);
    y = log(:,2);
%     y(1:10:end) = NaN;
    patchline(x,y,'edgecolor',colors{mod(i-1,6)+1},'linewidth',4,'edgealpha',.5);
  end
  
  if ~isempty(marker)
    for i = 1:numel(runId)
      log = loadlog(runSet,runId(i));
      x = log(:,4);
      y = log(:,2);
      patchline(x(1:20:end),y(1:20:end),'edgecolor',colors{mod(i-1,6)+1},'linewidth',2,'linestyle','none',marker{:});
    end
  end

  selectedPath = selectedPath ./ sum(selectedPath) * 100;
  
  fprintf('Average time steps: %.0f (%.0f).\n',mean(times(completed)), std(times(completed)));
  fprintf('Paths - N: %.0f, S: %.0f, NS: %.0f, SN: %.0f\n',selectedPath(1),selectedPath(2),selectedPath(3),selectedPath(4));
end