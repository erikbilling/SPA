
function setpath(CosivinaDir)
  SpaDir = cd;
  if nargin < 1
    CosivinaDir = '../Cosivina';
  end
  
  addpath(fullfile(SpaDir,'examples'));
  addpath(fullfile(SpaDir,'elements'));
  addpath(fullfile(SpaDir,'visualizations'));
  addpath(fullfile(SpaDir,'eb'));
  addpath(fullfile(SpaDir,'mathTools'));
  addpath(fullfile(SpaDir,'webots'));
  
  cd(CosivinaDir);
  run('setpath');
  cd(SpaDir);
  
end