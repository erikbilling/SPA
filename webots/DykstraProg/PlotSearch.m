function h = PlotSearch(ModelQ,x,maze,start,goal1,sub,decs,gString)

[N M] = size(maze);

h = subplot(2,1,sub);
xlim(gca,[0 N]);
ylim(gca,[0 M]);
box(gca,'on');
hold on

for i=1:size(ModelQ,1)
    if ModelQ(i) ~= 0
        text(x(i)+0.5,x(i,2)+0.5,num2str(ModelQ(i),decs),'FontSize',6);
    end
end
text(start(1)+0.3,start(2)+0.5,'S','FontName','Courier New','FontAngle',...
    'italic','FontSize',7);

text(goal1(1)+0.3,goal1(2)+0.5,gString,'FontName','Courier New',        ...
    'FontWeight','bold','FontSize',7);


[mx my] = find(maze);
for i=1:length(mx)
    rectangle('Position',[mx(i) my(i) 1 1],'EdgeColor',[.0 .0 .0],      ...
    'FaceColor',[.6 .6 .6]);
end

hold off
