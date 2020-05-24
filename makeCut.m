#basenames = {"5HDF9Y"; "5PAR9Y"; "5MDF9Y"; "5PLY9Y"};
pkg load image

filenames = dir('source');
mkdir('samples');
tic
  
for sample=3:size(filenames)(1)
  filename = filenames(sample, 1);
  [~, basename, ext] = fileparts (['source/' filename.name]);
  
  printf("%s: ", basename)

  im_highRes = imread(['source/' basename '.tiff']);
  
  im_crop = imcrop(im_highRes, [0    200  4960 4485]);
  imwrite(im_crop, ['samples/' basename '1.tiff']);
  im_crop = imcrop(im_highRes, [0    3100 4960 4485]);
  imwrite(im_crop, ['samples/' basename '2.tiff']);
  im_crop = imcrop(im_highRes, [0    6060 4960 4485]);
  imwrite(im_crop, ['samples/' basename '3.tiff']);
  im_crop = imcrop(im_highRes, [4960 200  4960 4485]);
  imwrite(im_crop, ['samples/' basename '4.tiff']);
  im_crop = imcrop(im_highRes, [4960 3100 4960 4485]);
  imwrite(im_crop, ['samples/' basename '5.tiff']);
  im_crop = imcrop(im_highRes, [4960 6060 4960 4485]);
  imwrite(im_crop, ['samples/' basename '6.tiff']);
  
  toc
endfor
