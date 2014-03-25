function matrix = mapzPart
  map.matrix = zeros(100);
  
  map.matrix(20:29,25:54) = 1;
  map.matrix(35:64,45:54) = 1;
  map.matrix(65:74,45:74) = 1;
  
  
  matrix = map.matrix;
  matrix([1:4 end-4:end],:) = 1;
  matrix(:,[1:4 end-4:end]) = 1;
end

