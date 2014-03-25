function [ maze,nrows,ncols ] = CreateMaze(nrows,ncols,discMult)

maze = zeros(nrows,ncols);

if discMult == 1
    maze(5:7,7) = 1;
    maze(5,5:6) = 1;
    maze(3:5,4) = 1;
    maze(6,3) = 1;
    maze(7,2) = 1;
    maze(8,1) = 1;
elseif discMult == 2
    maze(10:15,14:15) = 1;
    maze(10:11,10:13) = 1;
    maze(6:11,8:9) = 1;
    maze(12:13,6:7) = 1;
    maze(14:15,4:5) = 1;
    maze(16:17,2:3) = 1;
else 
    'discMult must be < 3',
end

end

