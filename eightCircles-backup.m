function outArray = eightCircles(im_highRes, gr_highRes)
  debug = false;
  holeRad = 300;

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

  eightArray = [];
  
  cnt = 0;
  
  for k = 1:13
    param1 = 175 + k*5;
    
    if debug
      printf("%d     ", param1);
    endif
    
    for param2=param2from:param2to
      #disp("Info: Hough circles 2.");
      circles = cv.HoughCircles(gr_highRes, 
                            'MinRadius', 100,
                            'MaxRadius', 360,
                            'Param1', param1, 
                            'Param2', param2,
                            'MinDist', 1400,
                            'DP', 1
                       )    
      #cumulate results in one array [x1 y1 x2 ... x16 y16]
      if(size(circles)(2) == 8)
        cnt += 1;
        
        circlesArrayOut = zeros(1, 16);
        circlesArray = zeros(8, 2);
        
        for hole=1:8
          circlesArray(hole, 1) = circles{hole}(1);  #x
          circlesArray(hole, 2) = circles{hole}(2);  #y
        endfor
                
        circlesArray = sortArray(circlesArray);
        
        for hole=1:8
          circlesArrayOut(1, (hole-1)*2 + 1) = circlesArray(hole, 2);  #x
          circlesArrayOut(1, (hole-1)*2 + 2) = circlesArray(hole, 1);  #y
        endfor
        
        #circlesArray = sortArray(circlesArray);
        eightArray = [eightArray; circlesArrayOut];
        
      endif
    
    endfor
    #outArray = [outArray; par2arr]; 
    if debug
      disp("");
    endif
    
    
      
  endfor
  
  outArray = [];
  
  for i=1:16
    [n, bin] = hist(eightArray(:,i), unique(eightArray(:,i)));
    [~,idx] = sort(-n);
    
    #outArray(fix((i-1)/2) + 1, rem(i, 2) + 1) = round(bin(idx(1)));
    outArray(1, i) = round(bin(idx(1)));
    #outArray(2, i) = n(idx(1));
    outArray(2, i) = round(bin(idx(2)));
    #outArray(4, i) = n(idx(2));
    #outArray(5, i) = round(bin(idx(3)));
    #outArray(6, i) = idx(3);
    #outArray(5, i) = round(mean(eightArray(:,i)));
  endfor  
    
  #eightArray = cnt;
endfunction