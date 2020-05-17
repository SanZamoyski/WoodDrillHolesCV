basenames = {"5HDF9Y"; "5PAR9Y"; "5MDF9Y"; "5PLY9Y"};
samplesNo = 4;
holeRad = 85;

#basenames = {"5PLY9Y"};
#samplesNo = 3;
#holeRad = 85;

cropSize = 300;
contrast = [0 0.3];
ratio = 0.125;

pkg load image
debug = false;

printf("Sample\tNo\tCoord\t\tCoord2\t\tDistance\n");

for b = 1:size(basenames)(1)
  for s = 1:samplesNo
    basename = basenames{b};
    imageNo = s;

    im_highResOrig = imread([basename '/' num2str(imageNo) '.tiff']);
    im_highRes = imadjust(im_highResOrig);

    if debug
      toc
    endif

    if debug
      disp("Info: Preparing image.");
    endif

    im_highRes = imadjust(im_highRes, contrast);
    gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');

    h = smallCoords(im_highRes, gr_highRes);

    if debug
      toc
    endif
    
    #im_highRes = cv.drawMarker(im_highRes, h, 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
    #im_highResCut = imcrop(im_highRes, [h(1)-cropSize/2+1 h(2)-cropSize/2+1 cropSize-2 cropSize-2]);
    #im_highResCut = cv.drawMarker(im_highResCut, [cropSize/2 cropSize/2], 'MarkerSize', 35, 'Color', 'b', 'Thickness', 1);
    #imwrite(im_highResCut, 'crosstest.png');
    
    #create new images and variables
    im_highResOrig = imcrop(im_highResOrig, [h(1)-cropSize/2+1 h(2)-cropSize/2+1 cropSize-2 cropSize-2]);
    
    im_highRes = imadjust(im_highResOrig);
    im_highRes = imadjust(im_highRes, contrast);
    gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
    h2 = [cropSize/2 cropSize/2];
    
    r = smallHough(gr_highRes, holeRad);
    
    im_highResMark = cv.drawMarker(im_highResOrig, h2, 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
    im_highResMark = cv.drawMarker(im_highResMark, r, 'MarkerSize', 35, 'Color', 'b', 'Thickness', 1);
    im_highResMark = cv.circle(im_highResMark, r, holeRad, 'Color', 'b', 'Thickness', 1);
    imwrite(im_highResMark, [basename '/Mark-' num2str(imageNo) '.png']);
    
    printf("%s\t%d\t%d %d\t%d %d\t\t%2.1f\n", basename, imageNo, h(1), h(2), r(1), r(2), norm(h2-r, 2));
    
    #return
  endfor
endfor