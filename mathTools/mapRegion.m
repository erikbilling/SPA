% mapRegion (COSIVINA toolbox)
%   Maps specified x and y region onto a larger matrix of specifed size. 
%
% Constructor call:
% map = mapRegion(yRegion,xRegion,matrixSize)
%   yRegion - y-range of specified region
%   yRegion - x-range of specified region
%   matrixSize - size of the target matrix
% Output:
%   map - subscript map for specified region
%
% Author: Erik Billing (erik.billing@his.se). 

function [ map ] = mapRegion(yRegion,xRegion,matrixSize)
    x = ones(length(yRegion),1)*((xRegion-1)*matrixSize(1));
    y = yRegion(:)*ones(1,length(xRegion));
    map = x+y;
end

