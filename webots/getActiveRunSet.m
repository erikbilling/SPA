function runSet = getActiveRunSet(runSets)
  if nargin < 1
    runSets = 'webots/epuck/runSets';
  end

  runSet = [];
  pathFile = [runSets '/runSet.txt'];
  if exist(pathFile,'file')
    f = fopen(pathFile,'r');
    while 1
      s = fgets(f);
      if s == -1
        return;
      elseif isempty(regexp(s,'^ *#.*'))
        break;
      end
    end

    runSet = [runSets '/' s];
  end
end

