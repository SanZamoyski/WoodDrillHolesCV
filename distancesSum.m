function sum = distancesSum(testPoints)
  sum = 0;
  
  sizeOfTP = size(testPoints)(2);
    
  for pointA = 0:2:sizeOfTP-4
    for pointB = pointA+2:2:sizeOfTP-2
      #fix((i-1)/2) + 1, rem(i, 2) + 1
      A = [testPoints(1, pointA + 1) testPoints(1, pointA + 2)];
      B = [testPoints(1, pointB + 1) testPoints(1, pointB + 2)];
      
      sum += norm(B - A);
    endfor
  endfor
    
endfunction
