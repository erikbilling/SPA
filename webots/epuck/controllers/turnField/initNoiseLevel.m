function nl = initNoiseLevel
  global noiseLevel
  
  runSet = getActiveRunSet('../../runSets');
  if ~isempty(regexp(runSet,'highnoise'))
    noiseLevel = 1;
  elseif ~isempty(regexp(runSet,'lownoise'))
    noiseLevel = 0.05;
  else
    noiseLevel = 0.005;
  end
  fprintf('Noise level: %.2f\n',noiseLevel);
  nl = noiseLevel;
end

