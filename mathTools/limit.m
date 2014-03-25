function v = limit(v,vmin,vmax)
  % V = limit(v,vmin,vmax) returns v, but never a value lower than vmin or
  % higher than vmax.
  
  if vmin > vmax
    error('Min value larger than max value!');
  end
  
  if v < vmin
    v = vmin;
  elseif v > vmax
    v = vmax;
  end
end

