basenames = {"5HDF9Y"; "5PAR9Y"; "5MDF9Y"; "5PLY9Y"};
pkg load image

tic

for sample=1:size(basenames)(1)
  basename = basenames{sample};
  printf("%s: ", basename);
  im_highRes = imread([basename '.tiff']);
  mkdir(basename);
  
  im_crop = imcrop(im_highRes, [0    0    4960 4960]);
  imwrite(im_crop, [basename '/1.tiff']);
  im_crop = imcrop(im_highRes, [4960 0    4960 4960]);
  imwrite(im_crop, [basename '/2.tiff']);
  im_crop = imcrop(im_highRes, [0    4960 4960 4960]);
  imwrite(im_crop, [basename '/3.tiff']);
  im_crop = imcrop(im_highRes, [4960 4960 4960 4960]);
  imwrite(im_crop, [basename '/4.tiff']);    
                    
  toc
endfor
