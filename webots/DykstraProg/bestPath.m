% bestPath (COSIVINA toolbox)
%   Computes the shortest path between start and goal in specified map.
%   The path is returned as an Nx3 list of N steps, where each row
%   specifies [distance,yCord,xCord].
%
% bestPath(maze,start,goal)
%   maze - a 2d matrix where 0 indicate open space and 1 indicate obstacles
%   start - [y x] matrix specifying the start position
%   goal - [y x] matrix specifying the goal position
% Author: Erik Billing (erik.billing@his.se) and Robert Lowe (robert.lowe@his.se). 

function [wpList] = bestPath(map,start,goal,radius)
  
  if nargin < 4
    radius = 4;
  end
    
  maze = conv2(map',disk(radius),'same');
  maze = maze/max(maze(:));
  rrange = -radius:radius;
  maze(start(1)+rrange,start(2)+rrange) = maze(start(1)+rrange,start(2)+rrange)-disk(radius);
  maze(goal(1)+rrange,goal(2)+rrange) = maze(goal(1)+rrange,goal(2)+rrange)-disk(radius);
  maze(maze<0) = 0;
  
  fsize = size(maze);
  N = fsize(1);
  M = fsize(2);
  statelist   = BuildStateList(N,M);
  nstates     = size(statelist,1);
  Ast_Model   = BuildAstModel(nstates);
  Pre_Steps   = zeros(nstates,1);
  
  cellH = 1; cellW = 1; cellDim = 1;
  
  %%
  discMult    = 1;
  subP        = 1;
  gString     = 'G';
  fs          = 7; % font size
  col         = [0 0 0];
  tit         = 'Dykstra path';
  type        = '--';
  graphica    = false;
  gVal        = 1;
  x           = start;
  %%
  bx = goal; g = 0; 
  sp = DiscretizeState(x,statelist); sVec = zeros(4); sVval = 1;
  AstSize = size(Ast_Model); fringeList = []; gList = zeros(AstSize(1),1); 
  goalReached = false;
  while (bx(1) ~= x(1) || bx(2) ~= x(2))                                      % while the back chained state is not equal to the current state
      %% Step 1: get upto four nearest (viable) neighbours from current state
      prevS = DiscretizeState(bx,statelist);
      
      for n = neighbors8(bx,N,M)
        neighbor = n';
        if maze(neighbor(1),neighbor(2)) == 0
          s1 = DiscretizeState(neighbor,statelist); 
          if Ast_Model(s1) == 0 && any(neighbor ~= goal)
              [h1,g] = getAstarState(neighbor,x,g,cellDim); 
              gList(s1) = gList(prevS) + eDist(bx,n);
              Ast_Model(s1) = h1 + gList(s1);
              fringeList(s1) = h1 + gList(s1); 
              Pre_Steps(s1) = prevS;
              if neighbor == start 
                goalReached = true;
                break; 
              end
          end
        end
      end
      
      if goalReached
        break;
      end
      
      %% Step 2: Sort (largest first) modelled values and assign to sVec list
      sVec = shuffle(sVec,fringeList); 
      %% Step 3: Pop expanded state from fringe (keep in A*Model for waypoints)
      popState = DiscretizeState(bx,statelist);
      fringeList(popState) = -1;                                              % pop: it is surrounded so no longer part of the fringe.
      sVec = shuffle(sVec,fringeList);                                        % re-sort the list following pop
      %% Step 4: Find new best state from the fringe
      newS = 0;
      for i=1:size(Ast_Model,1)
          if sVec(sVval) == Ast_Model(i) && fringeList(i)~=-1
              newS = i; break;
          end
      end
      bx = statelist(newS,:); 
  end

  
  if graphica == true
      PlotSearch(round(Ast_Model),statelist,maze,start,goal,subP,'%4.0f', ...
          gString);
  end

  lowestSoFar = 500; 
  for k=1:size(Ast_Model,1)
      if Ast_Model(k,1) < lowestSoFar && Ast_Model(k,1) ~=0 
          lowestSoFar = Ast_Model(k,1);
      end
  end
  minAst = lowestSoFar; 
  orgVals = Ast_Model;
  Ast_Model(:,1) = ((max(0,(Ast_Model(:,1).*(Ast_Model(:,1)>0)-minAst))/  ...
      ((max(Ast_Model)/(gVal))))); 
  for k=1:size(Ast_Model,1)
      if Ast_Model(k,1) == 1 Ast_Model(k,1) = 0; end
      if orgVals(k,1) == 1 orgVals(k,1) = 0; end
  end

  Ast_Model(DiscretizeState(goal,statelist),1) = 0;
  orgVals(DiscretizeState(goal,statelist),1) = 0;

  [wpList] = getWayPoints(orgVals,Pre_Steps,start,goal,statelist); % use x not start as the agent must plan from current position
end


%% Step 6: Get and plot path (waypoint list) from A* modelled values 
function [wpList] = getWayPoints(Ast_Model,Pre_Steps,start,goal,statelist)
  if numel(start) == 1
    if start == goal
      wpList = start;
    else
      wpList = [start;getWayPoints(Ast_Model,Pre_Steps,Pre_Steps(start),goal,statelist)];
    end
  else
    steps = getWayPoints(Ast_Model,Pre_Steps,DiscretizeState(start,statelist),DiscretizeState(goal,statelist),statelist);
    wpList = zeros(size(steps,1),3);
    for s = 1:size(steps,1)
      wpList(s,2:3) = statelist(steps(s),:);
      if s > 1
        wpList(s,1) = eDist(wpList(s,2:3),wpList(s-1,2:3)') + wpList(s-1,1);
      end
    end
  end
end

%wpList,
%% Calculate A* values (guarantees optimal path, unlike euclid. distance)
function[A_h,g] = getAstarState(s,sp,g,cellDim)
  %g = g*cellDim;
  h = eDist(s,sp');%*cellDim; 
  A_h = h + g;
  %% Shuffle/sort

end

function sVec = shuffle(sVec,fringe)
  tempList = []; sVec = sort(fringe,'descend'); kk = 1;
  while sVec(kk) ~= 0 && sVec(kk) ~= -1
      tempList(kk) = sVec(kk); kk = kk + 1;
  end
  sVec = sort(tempList,'ascend');        

end