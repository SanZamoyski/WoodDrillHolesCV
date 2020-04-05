pkg load io
pkg load image

basenames = {"3H9X"; "3H9Y"; "3M9X"; "3M9Y"; "3W9X"; "3W9Y"};
tic
printf("Samp    HC1 HC2 SPD\n") 

outputTxt = {"Samp" "HC1" "HC2" "SPD";};
mkdir("holeTest");

for sample=1:size(basenames)(1)
  for imageNo = 1:5
    for top=[false true]
      printf("%s%d", basenames{sample}, imageNo);
    
      im_highResOrig = imread([basenames{sample} '/' num2str(imageNo) '.tiff']);
  
      imSizeY = size(im_highResOrig, 1);
      imSizeX = size(im_highResOrig, 2);
      addPx = 350;
  
      if top > 0
        im_crop = imcrop(im_highResOrig, [0 0 imSizeX 2*addPx]);;
      else
        im_crop = imcrop(im_highResOrig, [0 imSizeY-2*addPx imSizeX 2*addPx]);
      endif
      
      printf("%s: ", trueTop(top));
    
      a = holeHoughTester(basenames{sample}, imageNo, top);
      xlswrite('holeTest/output.ods', a, [basenames{sample} "-" num2str(imageNo) "-" trueTop(top)]);
      #b = nonzeros(round(a(:)/5)*5);
      b=nonzeros(round(a(:)));
      
      [nb, binb] = hist(b, unique(b));
      [~,idxb] = sort(-nb);
      
      roundedVal1 = binb(idxb(1));
      roundedVal2 = binb(idxb(2));
      
      printf("%d %d ", roundedVal1, roundedVal2);
      
      #check if there is anything from simpleBlobDetector
      # close to Hough...
      b = holeBlobTester(basenames{sample}, imageNo, top);
      b = round(b(:));
      [n, bin] = hist(b, unique(b));

      spd = closestVal(roundedVal1, bin);
      
      printf("%d\n", spd);
      
      addPxS = 300;
      aimg = [];
      
      #18px ~ 0,1 mm
      mimg = cv.line(im_crop, [roundedVal1-addPxS 0], [roundedVal1-addPxS 2*addPx], 'Thickness', 3);
      mimg = cv.line(mimg,    [roundedVal1+addPxS 0], [roundedVal1+addPxS 2*addPx], 'Thickness', 3);
      mimg = cv.line(mimg,    [imSizeX/2-9 150], [imSizeX/2+9 150], 'Thickness', 3, 'Color', 'w');
      #imwrite(mimg, ["holeTest/" basenames{sample} num2str(imageNo) trueTop(top) "-" num2str(roundedVal1) "-HC1.tiff"]);
      mmimg = [mimg];
      aimg = [aimg, mimg];
      mm1 = mimg;
      
      mimg = cv.line(im_crop, [roundedVal2-addPxS 0], [roundedVal2-addPxS 2*addPx], 'Thickness', 3);
      mimg = cv.line(mimg,    [roundedVal2+addPxS 0], [roundedVal2+addPxS 2*addPx], 'Thickness', 3);
      mimg = cv.line(mimg,    [imSizeX/2-9 150], [imSizeX/2+9 150], 'Thickness', 3, 'Color', 'w');
      #imwrite(mimg, ["holeTest/" basenames{sample} num2str(imageNo) trueTop(top) "-" num2str(roundedVal2) "-HC2.tiff"]);
      mmimg = [mmimg; mimg;];
      aimg = [aimg, mimg];
      mm2 = mimg;
      
      mimg = cv.line(im_crop, [spd-addPxS 0], [spd-addPxS 2*addPx], 'Thickness', 3);
      mimg = cv.line(mimg,    [spd+addPxS 0], [spd+addPxS 2*addPx], 'Thickness', 3);
      mimg = cv.line(mimg,    [imSizeX/2-9 150], [imSizeX/2+9 150], 'Thickness', 3, 'Color', 'w');
      #imwrite(mimg, ["holeTest/" basenames{sample} num2str(imageNo) trueTop(top) "-" num2str(spd) "-spd.tiff"]);
      mmimg = [mmimg; mimg];
      aimg = [aimg, mimg];
      mm3 = mimg;
      
      #imwrite(mmimg, ["holeTest/" basenames{sample} num2str(imageNo) trueTop(top) ".tiff"]);
      outputTxt = [outputTxt; basenames{sample} num2str(roundedVal1) num2str(roundedVal2) num2str(spd);];
      
      aimg = {mm1, mm2, mm3};
      
      [~, h] = sort([roundedVal1 roundedVal2 spd]);
      mmimg = [aimg{h(1)}; aimg{h(2)}; aimg{h(3)};];
      imwrite(mmimg, ["holeTest/" basenames{sample} num2str(imageNo) trueTop(top) ".tiff"]);
      
      endfor
  endfor
endfor

xlswrite('holeTest/output.ods', outputTxt, "output");