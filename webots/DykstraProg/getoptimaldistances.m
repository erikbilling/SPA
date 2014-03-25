function distances = getoptimaldistances(map,start,goal)

  path = bestPath(map,start([2 1]),goal([2 1]));
  distances = diff(path(:,1));
end

