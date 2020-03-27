pkg load image
tic;
disp("Info: Loading image.");

basename = '3M9X';
contrast = [0 0.3];
ratio = 0.125;

j = 3;

im_highResOrig = imread([basename '/' num2str(j) '.tiff']);
im_highResOrig = imadjust(im_highResOrig);
toc

#imshow(im_highRes);
#return

disp("Info: Preparing image.");
im_highRes = imadjust(im_highResOrig, contrast);
im_lowRes = imresize(im_highRes, ratio, 'linear');
#toc

#disp("Info: Convert to grayscale.");
gr_highRes = cv.cvtColor(im_highRes, 'RGB2GRAY');
toc
#gr_highRes = cv.medianBlur(gr_highRes, 'KSize', 3);

disp("Info: Hough circles.");
circles = cv.HoughCircles(gr_highRes, 
                      #               https://dsp.stackexchange.com/a/22649
                      #
                      #If you have an idea what size circles you are looking for, 
                      # then it would be best to set min_radius and max_radius accordingly. 
                      # Otherwise, it will return anything circular of any size.
                      'MinRadius', 295,
                      'MaxRadius', 305,
                      
                      # Parameters 1 and 2 don't affect accuracy as such, more reliability. 
                      # Param 1 will set the sensitivity; how strong the edges of 
                      # the circles need to be. Too high and it won't detect anything, 
                      # too low and it will find too much clutter. 
                      # M:250, 
                      'Param1', 200, 
                      
                      # Param 2 will set how many edge points it needs to find to 
                      # declare that it's found a circle. Again, too high will detect nothing, 
                      # too low will declare anything to be a circle. The ideal 
                      # value of param 2 will be related to the circumference of the circles.
                      # M:10
                      'Param2', 8,
                      
                      'MinDist', 300,
                      
                      
                      #Inverse ratio of the accumulator resolution to the image resolution. For example, if DP=1, 
                      # the accumulator has the same resolution as the input image. If DP=2, 
                      # the accumulator has half as big width and height. default 1.
                      'DP', 1
                      
                      );    


                      
### TODO check if length(blobs1) is two or die


im_highResC = im_highResOrig;
disp("Info: Painting circles");
for i=1:length(circles)
    #blobs1(i).pt
#    blobs1s = [blobs1s; round(blobs1(i).pt];
    im_highResC = cv.circle(im_highResC, [round(circles{i}(1)) round(circles{i}(2))], round(circles{i}(3)),'Color', 'm', 'Thickness', 10);
    #im_lowResC = cv.drawMarker(im_lowResC, round(blobs1(i).pt), 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
end                      

#subplot(2, 2, 2);
#imshow(im_lowResC);
imwrite(im_highResC, 't_blobber.png');
