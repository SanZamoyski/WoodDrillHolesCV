function outArray = smallCoords(im_highRes, gr_highRes)
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

  par2arr = [];
  
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
          
          hx = 0;
          hy = 0;
          
          for hole = 1:8
            hx += circles{hole}(1);
            hy += circles{hole}(2);
          endfor
          
          #printf("%4.1f %4.1f\n", hx/8, hy/8);
            
        #average center point for this parameter add
        par2arr = [par2arr; hx/8 hy/8];
      endif
    
    endfor
    #outArray = [outArray; par2arr]; 
    if debug
      disp("");
    endif
    
  endfor
  
  outArray = round(mean(par2arr));
    
endfunction