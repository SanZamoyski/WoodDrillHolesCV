cropSize = 300;
contrast = [0 0.3];
ratio = 0.125;

reuse_img = 0;

pkg load image;
pkg load communications;

if reuse_img == 0
  im_highResOrig = imread('samples/PLY6A1.tiff');
  im_highRes = imadjust(im_highResOrig);
endif
  
  #im_highRes = imsmooth(im_highRes, "Perona and Malik");
  
im_highRes = imadjust(im_highRes, contrast);
gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');

mkdir('imfilter');

out = imsmooth(gr_highRes, "Disk", 5);
imwrite(out, "imfilter/imfilterTest-disk-05.tiff");
out = imsmooth(gr_highRes, "Disk", 15);
imwrite(out, "imfilter/imfilterTest-disk-15.tiff");
out = imsmooth(gr_highRes, "Disk", 20);
imwrite(out, "imfilter/imfilterTest-disk-20.tiff");
out = imsmooth(gr_highRes, "Disk", 25);
imwrite(out, "imfilter/imfilterTest-disk-25.tiff");

out = imsmooth(gr_highRes, "Gaussian", 0.25);
imwrite(out, "imfilter/imfilterTest-gaus-25.tiff");
out = imsmooth(gr_highRes, "Gaussian", 0.50);
imwrite(out, "imfilter/imfilterTest-gaus-50.tiff");
out = imsmooth(gr_highRes, "Gaussian", 0.75);
imwrite(out, "imfilter/imfilterTest-gaus-75.tiff");

out = imsmooth(gr_highRes, "Average", 5);
imwrite(out, "imfilter/imfilterTest-average-05.tiff");
out = imsmooth(gr_highRes, "Average", 10);
imwrite(out, "imfilter/imfilterTest-average-10.tiff");
out = imsmooth(gr_highRes, "Average", 15);
imwrite(out, "imfilter/imfilterTest-average-15.tiff");
out = imsmooth(gr_highRes, "Average", 20);
imwrite(out, "imfilter/imfilterTest-average-20.tiff");
out = imsmooth(gr_highRes, "Average", 25);
imwrite(out, "imfilter/imfilterTest-average-25.tiff");


out = imsmooth(gr_highRes, "Median", 5);
imwrite(out, "imfilter/imfilterTest-median-05.tiff");
out = imsmooth(gr_highRes, "Median", 10);
imwrite(out, "imfilter/imfilterTest-median-10.tiff");
out = imsmooth(gr_highRes, "Median", 15);
imwrite(out, "imfilter/imfilterTest-median-15.tiff");
out = imsmooth(gr_highRes, "Median", 20);
imwrite(out, "imfilter/imfilterTest-median-20.tiff");
out = imsmooth(gr_highRes, "Median", 25);
imwrite(out, "imfilter/imfilterTest-median-25.tiff");