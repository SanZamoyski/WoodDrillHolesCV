function outArray = holeHoughTester (basename, imageNo, top)
  debug = false;
  
  pkg load image
  tic;
  
  if debug
    disp("Info: Loading image.");
  endif


  contrast = [0 0.3];
  ratio = 0.125;
  addPx = 350;

  #j = 3;

  im_highResOrig = imread([basename '/' num2str(imageNo) '.tiff']);
  im_highResOrig = imadjust(im_highResOrig);
  
  if debug
    toc
  endif

  #imshow(im_highRes);
  #return

  if debug
    disp("Info: Preparing image.");
  endif
  
  im_highRes = imadjust(im_highResOrig, contrast);
  #im_lowRes = imresize(im_highRes, ratio, 'linear');
  #toc

  #disp("Info: Convert to grayscale.");
  gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
  if debug
    toc
  endif
  
  #gr_highRes = cv.medianBlur(gr_highRes, 'KSize', 3);

  imSizeY = size(gr_highRes, 1);
  imSizeX = size(gr_highRes, 2);

  if top > 0
    gr_crop = imcrop(gr_highRes, [0 0 imSizeX 2*addPx]);;
  else
    gr_crop = imcrop(gr_highRes, [0 imSizeY-2*addPx imSizeX 2*addPx]);
  endif
  
  #{
  gr_cropTop = imcrop(gr_highRes, [0 0 imSizeX 2*addPx]);
  gr_cropBot = imcrop(gr_highRes, [0 imSizeY-2*addPx imSizeX 2*addPx]);
  im_cropTop = imcrop(im_highRes, [0 0 imSizeX 2*addPx]);
  im_cropBot = imcrop(im_highRes, [0 imSizeY-2*addPx imSizeX 2*addPx]);
  #}

  ### END OF PREPARING IMAGES ###

  #{
  subplot(2, 1, 2);
  imshow(gr_cropTop);
  subplot(2, 2, 2);
  imshow(gr_cropBot);
  #}
 
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

  for k = 1:13
    param1 = 175 + k*5;
    
    if debug
      printf("%d     ", param1);
    endif
    
    par2arr = [];
    for param2=param2from:param2to
      #disp("Info: Hough circles 2.");
      circles = cv.HoughCircles(gr_crop, 
                            'MinRadius', 295,
                            'MaxRadius', 305,
                            'Param1', param1, 
                            'Param2', param2,
                            'MinDist', 300,
                            'DP', 1
                       );    
                       
      if(size(circles)(2))
          if debug
            printf("%4.1f   ", circles{1}(1)); 
          endif
        par2arr = [par2arr circles{1}(1)];
      else
        par2arr = [par2arr 0];
          if debug
            printf("         ");
          endif
      endif
    
    endfor
    outArray = [outArray; par2arr]; 
    if debug
      disp("");
    endif
    
  endfor
endfunction