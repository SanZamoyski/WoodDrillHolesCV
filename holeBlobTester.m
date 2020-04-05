function outArray = holeBlobTester (basename, imageNo, top)
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
  im_lowRes = imresize(im_highRes, ratio, 'linear');
  #toc

  #disp("Info: Convert to grayscale.");
  gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
  if debug
    toc
  endif
  
  #gr_highRes = cv.medianBlur(gr_highRes, 'KSize', 3);

  imSizeY = size(gr_highRes, 1);
  imSizeX = size(gr_highRes, 2);

  gr_cropTop = imcrop(gr_highRes, [0 0 imSizeX 2*addPx]);
  gr_cropBot = imcrop(gr_highRes, [0 imSizeY-2*addPx imSizeX 2*addPx]);
  im_cropTop = imcrop(im_highRes, [0 0 imSizeX 2*addPx]);
  im_cropBot = imcrop(im_highRes, [0 imSizeY-2*addPx imSizeX 2*addPx]);

  ### END OF PREPARING IMAGES ###


  #{subplot(2, 1, 2);
  imshow(gr_cropTop);
  subplot(2, 2, 2);
  imshow(gr_cropBot);
  #}
  
  if top
    gr_crop = gr_cropTop;
  else
    gr_crop = gr_cropBot;
  endif

  #{
  for k = 1:31
    param1 = 95 + k*5;
    
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
      elseif
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
  #}
  outArray = [];
  
  for mint=1:16
    oArray = [];
    #printf("mintreshold: %d\n", (mint-1)*8);
    for ts=1:16
      maxtArr = [];
      for maxt=1:8
        det1 = cv.SimpleBlobDetector(
                              'ThresholdStep', ts*16,
                              'MinThreshold', (mint-1)*8,
                              'MaxThreshold', 64+24*maxt,
                              'MinRepeatability', 2,
                              'MinDistBetweenBlobs', 10,
                              'FilterByColor', false,
                              'BlobColor', 0,
                              'FilterByArea', true,
                              'MinArea', 10000,
                              'MaxArea', 1000000,
                              'FilterByCircularity', false,
                              'MinCircularity', 0.8,
                              'MaxCircularity', realmax('single'),
                              'FilterByInertia', false,
                              'MinInertiaRatio', 0.5,
                              'MaxInertiaRatio', realmax('single'),
                              'FilterByConvexity', false,
                              'MinConvexity', 0.95,
                              'MaxConvexity', realmax('single')
                              );
                              
          blobs1 = det1.detect(gr_crop);
          
          #blobs1
          #imshow(gr_crop);
          
          if size(blobs1)
            maxtArr = [maxtArr blobs1(1).pt(1)];
          else
            maxtArr = [maxtArr 0];
          endif
          
      endfor
      oArray = [oArray; maxtArr];
    endfor
    #oArray
    outArray = [outArray; oArray];
  endfor
  #{
  if debug
    toc
  endif

  #Convert blobs to array
  outArray = vertcat(blobs1(1:end).pt(1));
  #}
  
endfunction