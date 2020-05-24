cropSize = 300;
contrast = [0 0.5];
ratio = 0.125;

holeRad = 300;
reuse_img = 0;

pkg load image;
pkg load communications;

if reuse_img == 0
  im_highResOrig = imread('samples/MDF6A2.tiff');
  #MDF5A4, PAR5A1, PAR5A2, PAR5A3, PAR5A4, PAR6A2
  
  #im_highRes = imadjust(im_highResOrig);
  #im_highRes = imadjust(im_highRes, contrast);
  #im_highRes = imsmooth(im_highRes, "Average", 5);
endif

mkdir('imfilter');

#im_highRes = imadjust(im_highRes, contrast);
gr_highRes = cv.cvtColor(im_highResOrig, 'RGB2GRAY');
[~, tr] = min(imhist(gr_highRes)(25:100));
tr += 75;

#bw_highRes = im2bw(im_highRes);
#bw_highRes = im2bw(im_highRes);
#bw_gray = mat2gray(bw_highRes)*255;
#bw_gray = imsmooth(bw_gray, "Disk", 25);

bw_gray = cv.threshold(gr_highRes, tr, 'Type', 'Trunc');
bw_gray = imadjust(bw_gray);

#[~, tr] = min(imhist(gr_highRes)(1:100));

#bw_gray = gr_highRes;
#empty = zeros(size(gr_highRes));
#for i=1:numel(gr_highRes)
#  if gr_highRes(i) > tr
#    bw_gray(i) = 255;
#  endif
#endfor

#bw_gray = changem(bw_gray, [255], [tr]);
#bw_gray(bw_gray == tr) = 255;

disp("OK");

for i=1:50
  printf("Param2 = %d", 51 - i);
  circles = cv.HoughCircles(bw_gray, 
                            'MinRadius', 290,
                            'MaxRadius', 310,
                            #'Param1', 50, 
                            'Param2', 51 - i,
                            'MinDist', 1430
                            #'DP', 1
                       );
                       
  printf(": %d\n", size(circles)(2));
  
  if size(circles)(2) > 7
    break
  endif
                       
endfor


#imwrite(bw_highRes, ['imfilter/bw.tiff']);
#imwrite(bw_highResOrig, ['imfilter/bw-orig.tiff']);

#ec1 = eightCircles(im_highRes, gr_highRes)
#ec2 = eightCircles(im_highRes, bw_highRes)
#ec3 = eightCircles(im_highRes, bw_highResOrig)

out = im_highResOrig;

for hole=1:size(circles)(2)
  #circlesArray(hole, 1) = circles{hole}(1);  #x
  #circlesArray(hole, 2) = circles{hole}(2);  #y
  out = cv.circle(out, [circles{hole}(1) circles{hole}(2)], holeRad, 'Color', 'm', 'Thickness', 3);
endfor

imwrite(out, 'can.png');