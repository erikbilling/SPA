
function setpath
  SpaDir = cd;
  cd ../Cosivina;
  run('setpath');
  cd(SpaDir);
  
  addpath(fullfile(SpaDir,'examples'));
  addpath(fullfile(SpaDir,'elements'));
  addpath(fullfile(SpaDir,'eb'));
end