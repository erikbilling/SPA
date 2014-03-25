function map = webotsMap(world,mapsize,padding,scale,trans,wallPattern)

  map = zeros(mapsize);

  if nargin < 3
    padding = [5 5];
  end
  if nargin < 4
    scale = [100 0 100];
  end
  if nargin < 5
    trans = [100 0 100];
  end
  if nargin < 6
    wallPattern = 'DEF Maze_Wall%d';
  end
  
  walls = webotsWorldObjects(world,wallPattern);
  
  for w = 1:length(walls)
    wtrans = walls(w).translation .* scale .* [1 1 -1] + trans ;
    wsize = walls(w).boxSize .* scale;
    if any(walls(w).rotation(1:3) - [0 1 0])
      warning('Wall%d has unhandled rotation',w);
    elseif walls(w).rotation(4) > pi / 4 && walls(w).rotation(4) < pi * 3/4 
        wsize = wsize([3 2 1]);
    end
    
    wtop = round(limit(wtrans(1) - wsize(1) / 2 + padding(1),1,mapsize(1)));
    wbottom = round(limit(wtrans(1) + wsize(1) / 2 + padding(1),1,mapsize(1)));
    wleft = round(limit(wtrans(3) - wsize(3) / 2 + padding(2),1,mapsize(2)));
    wright = round(limit(wtrans(3) + wsize(3) / 2 + padding(2),1,mapsize(2)));
%     fprintf('%d: Top: %f, Bottom: %f, Left: %f, Right: %f\n',w,wtop,wbottom,wleft,wright);
    map(wtop:wbottom,wleft:wright) = 1;
  end

end

