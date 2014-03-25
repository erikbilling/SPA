function [] = Astar_dykstraPathCalc()
%% variable declarations             
clear all
close all
%% params to fiddle with
discMult    = 2; % degree of discretization

if discMult == 1
    startX = 3; startY = 6;start = [startX startY];
    nrows = 10; ncols = 10;
    cellH = 10; cellW = 10; cellDim = 10;
else
    startX = 6; startY = 12; start = [startX startY];
    nrows = 20; ncols = 20;
    cellH = 5; cellW = 5; cellDim = 5;
end
[maze N M]  = CreateMaze(nrows,ncols,discMult);

statelist   = BuildStateList(N,M);
nstates     = size(statelist,1);
Ast_Model   = BuildAstModel(nstates);

if discMult == 1
    initG1x = 7; initG1y = 5;
elseif discMult == 2
    initG1x = 14; initG1y = 10;
end
goal        = [initG1x initG1y];    
%%
subP        = 1;
gString     = 'G';
fs          = 7; % font size
col         = [0 0 0];
tit         = 'Dykstra path';
type        = '--';
graphica    = true;
gVal        = 1;
x           = start;
%%
bx1 = []; bx2 = []; bx3 = []; bx4 = []; bx = goal; g = 0; 
sp = DiscretizeState(x,statelist); sVec = zeros(4); sVval = 1;
AstSize = size(Ast_Model); fringeList = []; gList = zeros(AstSize(1),1); 
while (bx(1) ~= x(1) || bx(2) ~= x(2))                                      % while the back chained state is not equal to the current state
    %% Step 1: get upto four nearest (viable) neighbours from current state
    prevS = DiscretizeState(bx,statelist);
    if bx(1) ~= N 
        if maze(bx(1) + 1,bx(2)) ~= 1 &&                                ...
        Ast_Model(DiscretizeState([bx(1)+1,bx(2)],statelist)) == 0 &&   ...
        (((bx(1) +1) ~= goal(1)) || (bx(2) ~= goal(2)))
            bx1(1) = bx(1) + 1; bx1(2) = bx(2); 
            s1 = DiscretizeState(bx1,statelist); 
            [h1,g] = getAstarState(bx1,x,g,cellDim); gList(s1) = gList(prevS) + 1;
            Ast_Model(s1) = h1 + gList(s1);fringeList(s1) = h1 + gList(s1); 
            if bx1 == start 
              break; 
            end
        end
    end
    if bx(1) ~= 1
        if maze(bx(1) - 1,bx(2)) ~= 1 &&                                ...
        Ast_Model(DiscretizeState([bx(1)-1,bx(2)],statelist)) == 0 &&   ...
        (((bx(1) - 1) ~= goal(1)) || (bx(2) ~= goal(2)))    
            bx2(1) = bx(1) - 1; bx2(2) = bx(2);
            s2 = DiscretizeState(bx2,statelist);
            [h2,g] = getAstarState(bx2,x,g,cellDim); gList(s2) = gList(prevS) + 1;
            Ast_Model(s2) = h2 + gList(s2);fringeList(s2) = h2 + gList(s2);
            if bx2 == start 
              break; end
        end
    end
    if bx(2) ~= M
        if maze(bx(1),bx(2)+1) ~= 1 &&                                  ...
        Ast_Model(DiscretizeState([bx(1),bx(2)+1],statelist)) == 0 &&   ...
        ((bx(1) ~= goal(1)) || ((bx(2)+1) ~= goal(2)))
            bx3(1) = bx(1); bx3(2) = bx(2) + 1; 
            s3 = DiscretizeState(bx3,statelist);
            [h3,g] = getAstarState(bx3,x,g,cellDim); gList(s3) = gList(prevS) + 1;
            Ast_Model(s3) = h3 + gList(s3);fringeList(s3) = h3 + gList(s3);
            if bx3 == start 
            break; end
        end
    end 
    if bx(2) ~= 1
        if maze(bx(1),bx(2)-1) ~= 1 &&                                  ...
        Ast_Model(DiscretizeState([bx(1),bx(2)-1],statelist)) == 0 &&   ...
        ((bx(1) ~= goal(1)) || ((bx(2)-1) ~= goal(2)))
            bx4(1) = bx(1); bx4(2) = bx(2) - 1;
            s4 = DiscretizeState(bx4,statelist);
            [h4,g] = getAstarState(bx4,x,g,cellDim); gList(s4) = gList(prevS) + 1;
            Ast_Model(s4) = h4 + gList(s4);fringeList(s4) = h4 + gList(s4);
            if bx4 == start 
            break; end
        end
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
%% Step 5: Plot plan branching back-chained from goal state

if graphica == true
    PlotSearch(round(Ast_Model),statelist,maze,start,goal,subP,'%4.0f', ...
        gString);
end

lowestSoFar = 500; N = 4;                                                   % N = nearest neighbours number
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

[wpList] = getWayPoints(orgVals,statelist,maze,x,goal,graphica,         ...
    gList,gString,fs,'%4.0f',col,tit,cellDim,discMult); % use x not start as the agent must plan from current position
%% Step 6: Get and plot path (waypoint list) from A* modelled values 
function [wpList] = getWayPoints(Ast_Model,stateList,maze,start,        ...
    goal,graphica,gList,gString,fs,decs,col,tit,cellDim,discMult)
sx = start; startx = DiscretizeState(goal,stateList); 
vals = []; wpList = zeros(1,3); count = 0; bestValSoFar = 1000000;          % arbitrary high value
%sx,
ss = startx; gList(ss) = 1000000;
while bestValSoFar ~= 0    
                                                    
    n1(1) = sx(1) + 1;  n1(2) = sx(2); s1 = DiscretizeState(n1,stateList);
    if ((Ast_Model(s1)==bestValSoFar && gList(ss)>gList(s1)) || Ast_Model(s1) < bestValSoFar) && ...
            (Ast_Model(s1) ~= 0 || (n1(1) == goal(1) && n1(2) == goal(2)))
        vals(1) = n1(1); vals(2) = n1(2); 
        dist = Ast_Model(DiscretizeState(vals,stateList)); bestValSoFar = dist;
    end
    n2(1) = sx(1) - 1;  n2(2) = sx(2); s2 = DiscretizeState(n2,stateList);
    if ((Ast_Model(s2)==bestValSoFar && gList(ss)>gList(s2)) || Ast_Model(s2) < bestValSoFar) && ...
            (Ast_Model(s2) ~= 0 || (n2(1) == goal(1) && n2(2) == goal(2))) 
        vals(1) = n2(1); vals(2) = n2(2); 
        dist = Ast_Model(DiscretizeState(vals,stateList)); bestValSoFar = dist;
    end
    n3(1) = sx(1); n3(2) = sx(2) + 1; s3 = DiscretizeState(n3,stateList);
    if ((Ast_Model(s3)==bestValSoFar && gList(ss)>gList(s3)) || Ast_Model(s3) < bestValSoFar) &&                                  ...
            (Ast_Model(s3) ~= 0 || (n3(1) == goal(1) && n3(2) == goal(2)))
        vals(1) = n3(1); vals(2) = n3(2); 
        dist = Ast_Model(DiscretizeState(vals,stateList)); bestValSoFar = dist;
    end
    n4(1) = sx(1); n4(2) = sx(2) - 1; s4 = DiscretizeState(n4,stateList);
    
    if ((Ast_Model(s4)==bestValSoFar && gList(ss)>gList(s4)) || Ast_Model(s4) < bestValSoFar) &&                                  ...
            (Ast_Model(s4) ~= 0 || (n4(1) == goal(1) && n4(2) == goal(2)))
        vals(1) = n4(1); vals(2) = n4(2); 
        dist = Ast_Model(DiscretizeState(vals,stateList)); bestValSoFar = dist;
    end
    %wpList,
    sx(1) = vals(1); sx(2) = vals(2); ss = DiscretizeState(vals,stateList);
    wpList(count + 1,1) = dist*cellDim;
    wpList(count + 1,2) = vals(1); wpList(count + 1,3) = vals(2);
    count = count +1; 
    if graphica == true && dist > 0
        PlotDykstraPath(vals,maze,start,goal,2,gString,fs,              ...
            wpList(count,1),col,tit,decs,discMult);
        wpList(count,1),
    end
end

%wpList,
%% Calculate A* values (guarantees optimal path, unlike euclid. distance)
function[A_h,g] = getAstarState(s,sp,g,cellDim)
%g = g*cellDim;
h = eDist(s,sp');%*cellDim; 
A_h = h + g;
%% Shuffle/sort
function sVec = shuffle(sVec,fringe)
tempList = []; sVec = sort(fringe,'descend'); kk = 1;
while sVec(kk) ~= 0 && sVec(kk) ~= -1
    tempList(kk) = sVec(kk); kk = kk + 1;
end
sVec = sort(tempList,'ascend');                                             % this is A* compatible sorting

