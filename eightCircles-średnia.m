function eightArray = eightCircles(im_highRes, gr_highRes)
  debug = false;

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

  eightArray = zeros(8, 2);
  
  cnt = 0;
  
  for k = 1:13
    param1 = 175 + k*5;
    
    if debug
      printf("%d     ", param1);
    endif
    
    for param2=param2from:param2to
      #disp("Info: Hough circles 2.");
      circles = cv.HoughCircles(gr_highRes, 
                            'MinRadius', 295,
                            'MaxRadius', 305,
                            'Param1', param1, 
                            'Param2', param2,
                            'MinDist', 1400,
                            'DP', 1
                       );    
      
      if(size(circles)(2) == 8)
        if debug
          printf("%4.1f   ", circles{1}(1));
          #circles 
        endif
        
        circlesArray = zeros(8, 2);
        
        for hole=1:8
          circlesArray(hole, 1) = circles{hole}(1);  #x
          circlesArray(hole, 2) = circles{hole}(2);  #y
        endfor
        
        circlesArray = sortArray(circlesArray);
        eightArray += circlesArray;
        
        cnt += 1;
        
      endif
    
    endfor
    #outArray = [outArray; par2arr]; 
    if debug
      disp("");
    endif
    
  endfor
  
  eightArray /= cnt;
endfunction