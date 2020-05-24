function [comb, err] = bestCombination(ec)
  #calculate nominal sum of distances:
  nominalPoints(1:6)   = [ 0        0           0        0.3*4800       0        0.6*4800 ];
  nominalPoints(7:10)  = [ 0.3*4800 0                                   0.3*4800 0.6*4800 ];       
  nominalPoints(11:16) = [ 0.6*4800 0           0.6*4800 0.3*4800       0.6*4800 0.6*4800 ];
  
  nom = distancesSum(nominalPoints);
  err = nom;
  
  sizeOfEc = size(ec)(2);
    
  for i=0:2^16-1
    testPoints = de2bi(i, 16, 'left-msb') .* ec(1, :) + ~de2bi(i, 16, 'left-msb') .* ec(2, :);
    
    sum = distancesSum(testPoints);
    newError = abs(sum - nom);
    
    #err
    #printf("Old:%f\tNew:%f\n", err, newError);
    
    if newError < err
      comb = testPoints;
      err = newError;
    endif
    
  endfor
  
endfunction