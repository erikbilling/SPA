function walls = webotsWorldObjects(world,pattern)
  f = fopen(world);
  
  if nargin < 2
    pattern = 'DEF Maze_Wall%d';
  end
  walls = struct;
  
  while ~feof(f)
    line = fgetl(f);
    wallId = sscanf(line,pattern);
    if ~isempty(wallId)
      walls(wallId).translation = sscanf(strtrim(fgetl(f)),'translation %f %f %f')';
      walls(wallId).rotation = sscanf(strtrim(fgetl(f)),'rotation %f %f %f %f')';
      walls(wallId).boxSize = sscanf(strtrim(fgetl(f)),'boxSize %f %f %f')';
    end
  end
end

