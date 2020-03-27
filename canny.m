pkg load image
tic;
disp("Info: Loading image.");

basename = '3W9X';
contrast = [0 0.3];
ratio = 0.125;

i = 2;

im_highRes = imread([basename '/' num2str(i) '.tiff']);
im_highRes = imadjust(im_highRes);
toc

#imshow(im_highRes);
#return

disp("Info: Preparing image.");
im_highRes = imadjust(im_highRes, contrast);
im_lowRes = imresize(im_highRes, ratio, 'linear');
#imshow(im_lowRes);
#toc

#disp("Info: Convert to grayscale.");
gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
toc
#gr_highRes = cv.medianBlur(gr_highRes, 'KSize', 3);

high = 150;

gr_canny = cv.Canny(gr_highRes, [high/2 high]);
imwrite(gr_canny, 't_canny.png');