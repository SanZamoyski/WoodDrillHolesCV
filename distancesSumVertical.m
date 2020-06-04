function sum = distancesSumVertical(testPoints)
  sum = 0;
  
  sizeOfTP = size(testPoints)(1);
    
  for pointA = 1:sizeOfTP-1
    for pointB = pointA+1:sizeOfTP
      #fix((i-1)/2) + 1, rem(i, 2) + 1
      A = [testPoints(pointA, 1) testPoints(pointA, 2)];
      B = [testPoints(pointB, 1) testPoints(pointB, 2)];
      
      #printf("%f %f, %f %f\n", testPoints(pointA, 1), testPoints(pointA, 2), testPoints(pointB, 1), testPoints(pointB, 2));
      
      sum += norm(B - A);
    endfor
  endfor
    
endfunction
