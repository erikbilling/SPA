
%% Speed plots, full obstacle, for four different conditons

axisDims = [1 1400 0 1];
h = figure;

subplot(4,2,2);
speedplot({'full-lownoise','full-highnoise'},183);
title('Fully obstructing obstacle inttroduced during early planning');
axis(axisDims);

subplot(4,2,4);
speedplot({'full-lownoise','full-highnoise'},208);
title('Fully obstructing obstacle introduced during late planning');
axis(axisDims);

subplot(4,2,6);
speedplot({'full-lownoise','full-highnoise'},162);
title('Fully obstructing obstacle introduced during early execution');
axis(axisDims);

subplot(4,2,8);
speedplot({'full-lownoise','full-highnoise'},226);
title('Fully obstructing obstacle introduced during late execution');
xlabel('time (simulation steps)');
axis(axisDims);


%% Speed plots, partial obstacle, for four different conditons

subplot(4,2,1);
speedplot({'part-lownoise','part-highnoise'},183);
title('Partly obstructing obstacle inttroduced during early planning');
axis(axisDims);

subplot(4,2,3);
speedplot({'part-lownoise','part-highnoise'},208);
title('Partly obstructing obstacle introduced during late planning');
axis(axisDims);

subplot(4,2,5);
speedplot({'part-lownoise','part-highnoise'},162);
title('Partly obstructing obstacle introduced during early execution');
axis(axisDims);

subplot(4,2,7);
speedplot({'part-lownoise','part-highnoise'},226);
title('Partly obstructing obstacle introduced during late execution');
axis(axisDims);
xlabel('time (simulation steps)');

set(h,'position',[200 100 1600 600]);
