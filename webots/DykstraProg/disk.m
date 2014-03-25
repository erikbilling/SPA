function [d] = disk(radius)

  range = -radius:radius;
  d = zeros(numel(range));
  for i = 1:length(range)
    x = range(i);
    for j = 1:length(range)      
      y = range(j);
      ed = sqrt(x*x+y*y);
      if ed <= radius
        d(j,i) = 1;
      end
    end
  end

end

