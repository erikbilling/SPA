function setpath(CosivinaDir)

TurnFieldDir = cd;
cd ../../../../
if nargin < 1
  setpath;
else
  setpath(CosivinaDir);
end
cd(TurnFieldDir);

end




