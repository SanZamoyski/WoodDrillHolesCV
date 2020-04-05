function cutForSamples(basename)
  debug = false;
  
  pkg load image
  tic;
  
  if debug
    disp("Info: Loading image.");
  endif

  #basename = '3W9X';

  im_highRes = imread([basename '.tiff']);
  if debug
    toc
  endif

  ratio = 0.125;
  addPx = 350;

  if debug
    disp("Info: Resizing image.");
  endif
  
  #This will convert 4800 dpi image to 600 dpi - good enough for cutting
  im_lowRes = imresize(im_highRes, ratio, 'linear');
  if debug
    toc
  endif
  
  #disp("Info: Convert to grayscale.");
  gr_lowRes = cv.cvtColor(im_lowRes, 'RGB2GRAY');

  #Preview original image resized
  if debug
    subplot(2,2,1);
    imshow(im_lowRes); 
    title("Original image");
  endif
  
  #define circles detectors
  #det1 is for „big” ones
  det1 = cv.SimpleBlobDetector(
                              #'FilterByCircularity', 1, 
                              #'MinCircularity', 0.8 
                              #'FilterByConvexity', 1,
                              #'MinConvexity', 0.1,
                              #'MaxConvexity', 1
                              'ThresholdStep', 10,
                              'MinThreshold', 50,
                              'MaxThreshold', 220,
                              'MinRepeatability', 2,
                              'MinDistBetweenBlobs', 10,
                              'FilterByColor', true,
                              'BlobColor', 0,
                              'FilterByArea', true,
                              'MinArea', 4000,
                              'MaxArea', 5000,
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

  if debug
    disp("Info: Detecting big blobs.");
  endif
  
  blobs1 = det1.detect(gr_lowRes);
  
  if debug
    toc
  endif

  #### todo: check if blobs number is 20, otherwise die


  #Convert blobs to array
  blobs1s = vertcat(blobs1(1:end).pt);
  blobs1s = sortrows(blobs1s, 2);

  blobs1sTop = vertcat(blobs1s(1:5, :));
  blobs1sBot = vertcat(blobs1s(end-4:end, :));

  im_lowResC = im_lowRes;
  #img_m = cv.drawMarker(img_m, blobs1(1).pt, 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
      
  #disp("Info: Painting crosses");
  #for i=1:length(blobs1)
  #    #blobs1(i).pt
  ##    blobs1s = [blobs1s; round(blobs1(i).pt];
  #    im_lowResC = cv.drawMarker(im_lowResC, round(blobs1(i).pt), 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
  #end

  if debug
    disp("Info: Painting lines, outputting files.");
  endif
  
  mkdir(basename);

  for i=1:5
    #line([blobs1sTop(i, 1), blobs1sBot(i, 1)], [blobs1sTop(i, 2), blobs1sBot(i, 2)]);
    #im_lowResC = insertShape(im_lowResC,
    #                  'Line', [blobs1sTop(i, 1), blobs1sBot(i, 1)], [blobs1sTop(i, 2), blobs1sBot(i, 2)], 
    #                  'LineWidth', 2,
    #                  'Color','blue');
    im_lowResC = cv.line(im_lowResC, 
                    round([blobs1sTop(i, 1) blobs1sTop(i, 2)]), 
                    round([blobs1sBot(i, 1) blobs1sBot(i, 2)]),
                    'Thickness', 1,
                    'LineType' , 'AA');
     
     minX = min(blobs1sTop(i, 1), blobs1sBot(i, 1))/ratio;
     minY = blobs1sTop(i, 2)/ratio;
     maxX = max(blobs1sTop(i, 1), blobs1sBot(i, 1))/ratio;
     maxY = blobs1sBot(i, 2)/ratio;
     
     im_crop = imcrop(im_highRes, 
                    [minX-addPx
                     minY-addPx
                     maxX-minX+2*addPx
                     maxY-minY+2*addPx
                    ]);
                     
     imwrite(im_crop, [basename '/' num2str(i) '.tiff']);
      
  endfor

  if debug
    subplot(2, 2, 2);
    imshow(im_lowResC);
    title("Founded blobs");
  endif
  
  imwrite(im_lowResC, [basename '/preview.png']);
    
  if debug
    toc    
  endif
endfunction