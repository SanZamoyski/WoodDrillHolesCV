pkg load image;
pkg load communications;

filenames = dir('samples');
mkdir('output');
tic

cropSize = 300;
contrast = [0 0.3];
ratio = 0.125;
resize = 0.2;

pkg load image
debug = false;

nominalPoints(1:6)   = [ 0        0           0        0.3*4800       0        0.6*4800 ];
nominalPoints(7:10)  = [ 0.3*4800 0                                   0.3*4800 0.6*4800 ];       
nominalPoints(11:16) = [ 0.6*4800 0           0.6*4800 0.3*4800       0.6*4800 0.6*4800 ];

nominalDistance = distancesSum(nominalPoints);

printf("Sample\t\tCoord\t\tCoord2\t\tParam2\tErr\t\tDistance\n");

for b = 3:size(filenames)(1)
  filename = filenames(b, 1);
  [~, basename, ext] = fileparts (['samples/' filename.name]);
  
  printf("%s:\t\t", basename)
  
  holeRad = str2num(basename(4))*4800/508;
    
  im_highResOrig = imread(['samples/' basename '.tiff']);
  
  gr_highRes = cv.cvtColor(im_highResOrig, 'RGB2GRAY');
  [~, tr] = min(imhist(gr_highRes)(25:100));
  tr += 75;
  bw_gray = cv.threshold(gr_highRes, tr, 'Type', 'Trunc');
  bw_gray = imadjust(bw_gray);

  #im_highRes = imadjust(im_highResOrig);
  
  #bw_highRes = im2bw(im_highRes);
  #bw_gray = mat2gray(im2bw(im_highRes))*255;

  #im_highRes = imadjust(im_highRes, contrast);
  #gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');

  #ec = eightCircles(im_highRes, gr_highRes);
  #h = round(mean(ec));

  #ec = eightCircles(im_highRes, gr_highRes);
  [ec, param2] = eightCircles(bw_gray);
  #ec = bestCombination(ec);
  realDistance = distancesSum(ec);
  ec = convertTo2x8(ec);
  h = round(mean(ec));
  
  im_out = imresize(im_highResOrig, resize);   
  
  for i=1:8
    #printf("%d %f %f\n", i, ec(i, 1), ec(i, 2));
    im_out = cv.circle(im_out, [ec(i, 1) ec(i, 2)] * resize, 300 * resize, 'Color', 'b', 'Thickness', 1);
  endfor

  if debug
    toc
  endif
  
  #im_highRes = cv.drawMarker(im_highRes, h, 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
  #im_highResCut = imcrop(im_highRes, [h(1)-cropSize/2+1 h(2)-cropSize/2+1 cropSize-2 cropSize-2]);
  #im_highResCut = cv.drawMarker(im_highResCut, [cropSize/2 cropSize/2], 'MarkerSize', 35, 'Color', 'b', 'Thickness', 1);
  #imwrite(im_highResCut, 'crosstest.png');
  
  #create new images and variables
  im_highResOrig = imcrop(im_highResOrig, [h(1)-cropSize/2+1 h(2)-cropSize/2+1 cropSize-2 cropSize-2]);
  bw_gray = imcrop(bw_gray, [h(1)-cropSize/2+1 h(2)-cropSize/2+1 cropSize-2 cropSize-2]);
  
  #im_highRes = imadjust(im_highResOrig);
  #im_highRes = imadjust(im_highRes, contrast);
  #gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
  h2 = [cropSize/2 cropSize/2];
  
  r = smallHough(bw_gray, holeRad);
  
  im_highResMark = cv.drawMarker(im_highResOrig, h2, 'MarkerSize', 69, 'Color', 'b', 'Thickness', 1);
  im_highResMark = cv.drawMarker(im_highResMark, r, 'MarkerSize', 35, 'Color', 'm', 'Thickness', 1);
  im_highResMark = cv.circle(im_highResMark, r, holeRad, 'Color', 'm', 'Thickness', 1);
  
  % 'specific location' point
  y = round((h(1)) * resize - cropSize/2);
  x = round((h(2)) * resize - cropSize/2);
  s = size(im_highResMark);
  im_out(x:x+s(1)-1, y:y+s(2)-1, :) = im_highResMark;
  
  imwrite(im_out, ['output/' basename '.png']);
  
  printf("%d %d\t%d %d\t%d\t%d\t\t%2.1f\n", h(1), h(2), r(1), r(2), param2, abs(nominalDistance - realDistance), norm(h2-r, 2));
  
  fid = fopen (['output/' basename '.txt'], "w");
  fprintf(fid, "%s:\t\t%d %d\t%d %d\t\t%d\t%d\t\t%2.1f\n", basename, h(1), h(2), r(1), r(2), param2, abs(nominalDistance - realDistance), norm(h2-r, 2));
  fclose (fid);
  
endfor