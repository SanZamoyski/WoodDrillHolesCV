pkg load image

disp("Info: Loading image.");

im = imread('W0.90D20.png');
imres = 1;

disp("Info: Resizing image.");
im = imresize(im, imres, 'linear');

#im_b = cv.medianBlur(im, 'KSize', 11);

gr = cv.cvtColor(im, 'RGB2GRAY');
#gr = cv.threshold(gr, 64);

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
                            'MinArea', 3000*imres*imres,
                            'MaxArea', 4000*imres*imres,
                            'FilterByCircularity', false,
                            'MinCircularity', 0.9,
                            'MaxCircularity', realmax('single'),
                            'FilterByInertia', true,
                            'MinInertiaRatio', 0.1,
                            'MaxInertiaRatio', realmax('single'),
                            'FilterByConvexity', false,
                            'MinConvexity', 0.95,
                            'MaxConvexity', realmax('single')
                            );

#det2 is for small ones                            
det2 = cv.SimpleBlobDetector(
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
                            'MinArea', 200*imres*imres,
                            'MaxArea', 350*imres*imres,
                            'FilterByCircularity', false,
                            'MinCircularity', 0.8,
                            'MaxCircularity', realmax('single'),
                            'FilterByInertia', true,
                            'MinInertiaRatio', 0.1,
                            'MaxInertiaRatio', realmax('single'),
                            'FilterByConvexity', true,
                            'MinConvexity', 0.95,
                            'MaxConvexity', realmax('single')
                            );

#Preview original image                        
subplot(2,2,1);
imshow(gr);                         

disp("Info: Detecting big blobs.");
blobs1 = det1.detect(gr);

#Convert blobs to array
blobs1s = vertcat(blobs1(1:end).pt);
img_m = im;
#img_m = cv.drawMarker(img_m, blobs1(1).pt, 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
    
disp("Info: Painting crosses");
for i=1:length(blobs1)
    #blobs1(i).pt
#    blobs1s = [blobs1s; round(blobs1(i).pt];
    img_m = cv.drawMarker(img_m, round(blobs1(i).pt), 'MarkerSize', 69, 'Color', 'm', 'Thickness', 1);
end

subplot(2, 2, 2);
imshow(img_m);


#[centers, radii] = imfindcircles (gr, [1 100]);
#viscircles (centers, radii)
#title ("found circles in red")

disp("Info: HoughCircles");
#circles = cv.HoughCircles(gr, 'DP', 2, 'MinDist', 10, 'Param1', 30, 'Param2', 30, 'MinRadius', 5, 'MaxRadius', 50)                            
circles = cv.HoughCircles(gr, 
                      'DP', 0.5, 
                      'MinDist', 30, 
                      'Param1', 100, 
                      'Param2', 1, 
                      'MinRadius', 30, 
                      'MaxRadius', 80);    

disp("Info: Painting circles");
for i=1:length(circles)
    #blobs1(i).pt
#    blobs1s = [blobs1s; round(blobs1(i).pt];
    img_m = cv.circle(img_m, [round(circles{i}(1)) round(circles{i}(2))], 2);
end                      



disp("Info: writing image.");
imwrite(img_m, 'output.png');
                      
return

#find points to create lines
#both arrays - 2nd point is rightBottom
rightLine = sortrows(sortrows(blobs1s, -1)(1:2,:), 2);
botLine = sortrows(sortrows(blobs1s, -2)(1:2,:), 1);

#calculate two angles to check if all three points 
# are recognised correctly. atan2(y2-y1,x2-x1)
ang1 = atan2(rightLine(2,2) - rightLine(1,2), rightLine(2,1) - rightLine(1,1)) - pi/2;
ang2 = atan2(botLine(2,2) - botLine(1,2), botLine(2,1) - botLine(1,1));

#Return info if there is something wrong
if abs(ang1-ang2) > pi/180
  disp('Warn: Orientation points error.');
  #return
endif

#Rotate image and recreate all we need
disp("Info: Rotating image.");
im = rotateAround(im, rightLine(2,2), rightLine(2,1), (ang1 + ang2)/2*180/pi);
im_b = cv.medianBlur(im, 'KSize', 11);

gr = cv.cvtColor(im_b, 'RGB2GRAY');
gr = cv.threshold(gr, 64);

#Show unrotated image
subplot(2,2,2);
imshow(gr);

#Detect again big points
blobs1 = det1.detect(gr);

#Convert blobs to array
blobs1s = blobs1(1).pt;
for i=2:length(blobs1)
    #blobs1(i).pt
    blobs1s = [blobs1s; blobs1(i).pt];
end

blobs1s = sort(blobs1s);

disp("Info: cropping image.");
im = imcrop(im, [blobs1s(1,1) blobs1s(1,2) blobs1s(3,1)-blobs1s(1,1)-1 blobs1s(3,2)-blobs1s(1,2)-1] );

#Show cropped image
subplot(2,2,3);
imshow(im);

im_b = cv.medianBlur(im, 'KSize', 11);

img_m = im;

gr = cv.cvtColor(im_b, 'RGB2GRAY');
gr = cv.threshold(gr, 64);

[nc, nr] = size(gr);

if abs(nc-nr) > 0
  disp("Warn: Rotated and cropped image size error. Diff is: ");
  disp(abs(nc-nr));
  #return
endif

disp("Info: 600dpi  => 1cm = 236.220472px");
disp("Info: 1200dpi => 1cm = 472.440945px");
disp("Info: 2400dpi => 1cm = 944.88189px");
dist = nc/5

#if rem(nc, 5)
#  disp("Warning: cropped image should be divisable by 5.");
#endif

disp("Info: drawing markers.");
for i=0:5
  for j=0:5
    img_m = cv.drawMarker(img_m, [dist/2+i*dist dist/2+j*dist], 'Color', 'm', 'Thickness', 1);
  endfor
endfor

subplot(2,2,4);
imshow(img_m);

disp("Info: writing image.");
imwrite(img_m, 'output.png');

#sort(blobs1.pt)
return
diex;

#blobs1s = sort(blobs1.pt, 2);

for i=1:length(blobs1)
    #if blobs(i).size > 5
        img_m = cv.drawMarker(img_m, blobs1(i).pt, 'Color', 'm', 'Thickness', 4);
    #end
end

blobs2 = det2.detect(gr);


for i=1:length(blobs2)
    #if blobs(i).size > 5
        img_m = cv.drawMarker(img_m, blobs2(i).pt, 'Color', 'g', 'Thickness', 2);
    #end
end

#for i=1:length(circles)
#    # draw the outer circle
#    cimg = cv.circle(cimg, 
#                     [circles{i}(1), circles{i}(2)], 
#                     circles{i}(3),
#                     #10, 
#                     'Color', 'r');
#end

subplot(2,2,4);
#imshow (cimg);
imshow(img_m);