
function setpath
  SpaDir = cd;
  
  addpath(fullfile(SpaDir,'examples'));
  addpath(fullfile(SpaDir,'elements'));
  addpath(fullfile(SpaDir,'visualizations'));
  addpath(fullfile(SpaDir,'eb'));
  addpath(fullfile(SpaDir,'mathTools'));
  
  cd ../Cosivina;
  run('setpath');
  cd(SpaDir);
  
end