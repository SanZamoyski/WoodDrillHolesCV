function outArray = smallHough(gr_highRes, holeRad)
  debug = false;
  sizeMarginL = 25;
  sizeMarginH = 0;
  
  tic;
  
  outArray = [];

  param2from = 4;
  param2to   = 9;

  if debug
    printf("Param2:");
  endif
  
  if debug
    for param2=param2from:param2to
      printf("%3d     ", param2);
    endfor
    printf("\n");
  endif

  par2arr = [];
  
  for k = 1:13
    param1 = 175 + k*5;
    
    if debug
      printf("%d     ", param1);
    endif
    
    for param2=param2from:param2to
      #disp("Info: Hough circles 2.");
      circles = cv.HoughCircles(gr_highRes, 
                            'MinRadius', holeRad/2,
                            'MaxRadius', holeRad*1.2,
                            'Param1', param1, 
                            'Param2', param2,
                            'MinDist', 1400,
                            'DP', 1
                       );    
      
      if(size(circles)(2) == 1)
        if debug
          printf("%4.1f   ", circles{1}(1));
          #circles 
        endif
          
        par2arr = [par2arr; circles{1}(1) circles{1}(2)];
      endif
    
    endfor
    #outArray = [outArray; par2arr]; 
    if debug
      disp("");
    endif
    
  endfor
  
  #par2arr
  outArray = round(mean(par2arr));
    
endfunction
