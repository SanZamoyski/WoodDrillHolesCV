function outArray = smallCoords(im_highRes, gr_highRes)

  par2arr = eightCircles(im_highRes, gr_highRes);
  outArray = round(mean(par2arr));
    
endfunction