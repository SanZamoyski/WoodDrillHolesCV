function rms = calcRms(arr1, arr2)
  art = arr1 - arr2;
  sum = 0;
  
  for i=1:size(arr1)(1)
    sum += norm(art(i));
  endfor
  
  rms = sqrt(sum/size(arr1)(1));
  
endfunction
