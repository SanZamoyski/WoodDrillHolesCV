cropSize = 300;
contrast = [0 0.3];
ratio = 0.125;

reuse_img = 0;

pkg load image;
pkg load communications;

if reuse_img == 0
  im_highResOrig = imread('samples/PLY6A1.tiff');
  im_highRes = imadjust(im_highResOrig);
  
  #im_highRes = imsmooth(im_highRes, "Perona and Malik");
  
  im_highRes = imadjust(im_highRes, contrast);
  gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
  gr_highRes = imsmooth(gr_highRes, "Disk", 25);
endif

ec = eightCircles(im_highRes, gr_highRes);
bc = bestCombination(ec);

ec = convertTo2x8(ec);
bc = convertTo2x8(bc);

##im_highResMark = cv.drawMarker(im_highResOrig, h2, 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
##im_highResMark = cv.drawMarker(im_highResMark, r, 'MarkerSize', 35, 'Color', 'b', 'Thickness', 1);
  
im_highResMarkEC = im_highResOrig;
im_highResMarkBC = im_highResOrig;
  
for i=1:8
  printf("%d\t%d\t%d\t\t%d\t%d\n", i, ec(i, 1), ec(i, 2), bc(i, 1), bc(i, 2));
  im_highResMarkEC = cv.circle(im_highResMarkEC, [ec(i, 1) ec(i, 2)], 300, 'Color', 'b', 'Thickness', 3);
  im_highResMarkBC = cv.circle(im_highResMarkBC, [bc(i, 1) bc(i, 2)], 300, 'Color', 'b', 'Thickness', 3);
endfor

imwrite(im_highResMarkEC, 'ecTest-disk-ec.png');
imwrite(im_highResMarkBC, 'ecTest-disk-bc.png');