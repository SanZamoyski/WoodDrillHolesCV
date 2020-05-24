function sortedArray = sortArray(arrayToSort)
  #blobs1s = sortrows(blobs1s, 2);
  #blobs1sTop = vertcat(blobs1s(1:5, :));
  #blobs1sBot = vertcat(blobs1s(end-4:end, :));
  
  arr = sortrows(arrayToSort, 2);
  
  sortedArray = sortrows(arr(1:3, :), 1);
  sortedArray = [sortedArray; sortrows(arr(4:5, :), 1)];
  sortedArray = [sortedArray; sortrows(arr(6:8, :), 1)];
  #sortedArray = arr;
  
endfunction
