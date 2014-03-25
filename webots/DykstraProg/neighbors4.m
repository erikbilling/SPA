
function ns = neighbors4(point,yMax,xMax)
  n = zeros(2,4);
  n(:,1) = point+[ 1  0];
  n(:,2) = point+[-1  0];
  n(:,3) = point+[ 0  1];
  n(:,4) = point+[ 0 -1];
  
  inborders = ones(1,4);
  inborders(n(1,:)<1) = 0;
  inborders(n(2,:)<1) = 0;
  inborders(n(1,:)>yMax) = 0;
  inborders(n(2,:)>xMax) = 0;
  
  ns = n(:,find(inborders));
end