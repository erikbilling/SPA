function[h] = PlotDykstraPath(x,maze,start,goal1,sub,gString,fs,type,   ...
                    col,tit,decs,discMult)

[N M] = size(maze);
h = subplot(2,1,sub);
title(tit);
ax=get(h,'Position');
ax(4)=ax(4)+0.1; 
xlim(gca,[0 N]);
ylim(gca,[0 M]);
box(gca,'on');
hold on
%set(gcf,'Position',[100 100 100 100])
ModelQ = type;

text(x(1)+0.5,x(2)+0.5,num2str(ModelQ,decs),'FontSize',fs,'Color',col);

%% start state graphics
colSG = 0.75;
if discMult == 1
    rectangle('Position',[start(1) start(2) 1 1],                       ...
    'EdgeColor',[colSG colSG colSG],'FaceColor',[colSG colSG colSG]);
elseif discMult == 2
    rectangle('Position',[start(1) start(2) 2 2],                       ...
    'EdgeColor',[colSG colSG colSG],'FaceColor',[colSG colSG colSG]);
end
text(start(1)+0.3,start(2)+0.5,'S','FontName','Courier New','FontAngle',...
    'italic','FontSize',fs,'Color',[1 0 0]);
%% goal state graphics
if discMult == 1
     rectangle('Position',[goal1(1) goal1(2) 1 1],'EdgeColor',          ...
     [colSG colSG colSG],'FaceColor',[colSG colSG colSG]);
elseif discMult == 2
     rectangle('Position',[goal1(1) goal1(2) 2 2],'EdgeColor',          ...
     [colSG colSG colSG],'FaceColor',[colSG colSG colSG]); 
end
text(goal1(1)+0.3,goal1(2)+0.5,gString,'FontName','Courier New',        ...
    'FontWeight','bold','FontSize',fs,'Color',col);
[mx my] = find(maze);

for i=1:length(mx)
    rectangle('Position',[mx(i) my(i) 1 1],'EdgeColor',[.0 .0 .0],      ...
        'FaceColor',col);
end

drawnow
hold off
