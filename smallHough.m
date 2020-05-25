function [oneArray, param2] = smallHough(gr_highRes, holeRad)
  debug = false;
  sizeMarginL = 25;
  sizeMarginH = 0;
  
  tic;
  
  outArray = [];
  oneArray = [];
  
  for k = 1:50
    param2 = 51 - k;
    circles = cv.HoughCircles(gr_highRes, 
                            'MinRadius', holeRad - 5,
                            'MaxRadius', holeRad + 5,
                            #'Param1', param1, 
                            'Param2', param2,
                            'MinDist', 1400
                            #'DP', 1
                       );    
      
    if(size(circles)(2) == 1)
      if debug
        printf("%4.1f   ", circles{1}(1));
        #circles 
      endif
        
      oneArray = [circles{1}(1) circles{1}(2)];
      return
    endif
  
  endfor

  #{
  for i=1:2
    [n, bin] = hist(oneArray(:,i), unique(oneArray(:,i)));
    [~,idx] = sort(-n);
    
    #outArray(fix((i-1)/2) + 1, rem(i, 2) + 1) = round(bin(idx(1)));
    outArray(1, i) = round(bin(idx(1)));
    #outArray(2, i) = n(idx(1));
    
    #outArray(2, i) = round(bin(idx(2)));
    
    #outArray(4, i) = n(idx(2));
    #outArray(5, i) = round(bin(idx(3)));
    #outArray(6, i) = idx(3);
    #outArray(5, i) = round(mean(eightArray(:,i)));
  endfor  
  #}
  #outArray = round(mean(par2arr));
    
endfunction
