function val = closestVal(needle, stack)
  val = 0;
  dist = 1000000;
  
  for k=1:length(stack)
    if abs(needle-stack(k)) < dist
      val = stack(k);
      dist = abs(needle-stack(k));
    endif
  endfor
endfunction
