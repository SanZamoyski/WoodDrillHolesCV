function [center, bestRms, bestDistSum, bestRotation] = correctedCenter(nominalPoints, realPoints)
  nominalPointsZero = nominalPoints - mean(nominalPoints);  
  realPointsZero = realPoints - mean(realPoints);

  bestRotation = 0;
  bestMoveX = 0;
  bestMoveY = 0;
  bestDistSum = 10000;

  deltaCoord = fix(max(max(abs(realPointsZero - nominalPointsZero))));
  deltaTheta = 3;
  
  for theta=-deltaTheta:0.01:deltaTheta %TO ROTATE CLOCKWISE BY X DEGREES
    for deltaX = -deltaCoord:deltaCoord
      for deltaY = -deltaCoord:deltaCoord
        rotationMatrix=[cosd(theta) -sind(theta); sind(theta) cosd(theta)]; %CREATE THE MATRIX
        realPointsZeroRotated = realPointsZero * rotationMatrix' + [deltaX deltaY]; %MULTIPLY VECTORS BY THE ROT MATRIX and move by X and Y

        #dSum = calcDistSum(nominalPointsZero, realPointsZeroRotated);
        dSum = sum(sum(abs(realPointsZeroRotated - nominalPointsZero)));  #R:0.230000, X:2, Y:0, dSum: 68.6065, RMS: 1.869584
        #dSum = calcRms(realPointsZeroRotated, nominalPointsZero);        #R:0.300000, X:1, Y:-12, dSum: -----, RMS: 1.869510
        
        if dSum < bestDistSum
          bestRotation = theta;
          bestMoveX = deltaX;
          bestMoveY = deltaY;
          bestDistSum = dSum;
          bestRms = calcRms(realPointsZeroRotated, nominalPointsZero);
          #printf(".");
        endif
        
      endfor
    endfor
    #printf("th: %f, R:%f, X:%d, Y:%d, dSum: %d, RMS: %f\n", theta, bestRotation, bestMoveX, bestMoveY, bestDistSum, bestRms); 
  endfor

  center =  mean(realPoints) + [bestMoveX bestMoveY];

endfunction
