function plotspeeds(log,obstacle)

  speeds = getspeeds(log);
  plot((1:length(speeds))*5,speeds,'linewidth',2,'color','black');
  line([obstacle obstacle],[0 1],'linewidth',3);

end

