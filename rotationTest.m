nominalPoints   =      [  0           0       
                          0.3*4800    0            
                          0.6*4800    0         
                          0           0.3*4800  
                          0.6*4800    0.3*4800   
                          0           0.6*4800            
                          0.3*4800    0.6*4800        
                          0.6*4800    0.6*4800 ];
                          
realPoints = [  750.50    679.50
               2180.50    664.50
               3618.50    661.50
                744.50   2115.50
               3624.50   2108.50
                759.50   3565.50
               2191.50   3562.50
               3636.50   3553.50];
      
nominalPointsZero = nominalPoints - mean(nominalPoints);  
realPointsZero = realPoints - mean(realPoints);

bestRotation = 0;
bestMoveX = 0;
bestMoveY = 0;
bestDistSum = 10000;

tic

delta = fix(max(max(abs(realPointsZero - nominalPointsZero))));

for theta=-10:0.01:10 %TO ROTATE CLOCKWISE BY X DEGREES
  for deltaX = -delta:delta
    for deltaY = -delta:delta
      rotationMatrix=[cosd(theta) -sind(theta); sind(theta) cosd(theta)]; %CREATE THE MATRIX
      realPointsZeroRotated = realPointsZero * rotationMatrix' + [deltaX deltaY]; %MULTIPLY VECTORS BY THE ROT MATRIX and move by X and Y

      #dSum = calcDistSum(nominalPointsZero, realPointsZeroRotated);
      dSum = sum(sum(abs(realPointsZeroRotated - nominalPointsZero)));
      
      if dSum < bestDistSum
        bestRotation = theta;
        bestMoveX = deltaX;
        bestMoveY = deltaY;
        bestDistSum = dSum;
        bestRms = calcRms(realPointsZeroRotated - nominalPointsZero);
        #printf(".");
      endif
      
    endfor
  endfor
  printf("th: %f, R:%f, X:%d, Y:%d, dSum: %d\n", theta, bestRotation, bestMoveX, bestMoveY, bestDistSum); 
endfor

toc

return                          
                          
distancesSumVertical(nominalPoints)

% Create rotation matrix
theta = 90; % to rotate 90 counterclockwise
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

rotatedPoints = [];

for i=1:size(nominalPoints)(1)
  
endfor

distancesSumVertical(R*nominalPoints)