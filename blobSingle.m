basename = "3W9X";
holeNo = 1;

#printf("Samp No SPD\n") 

a = holeBlobTester(basename, holeNo, true)
#printf("%s-%d should be 634-639 and is %d\n", basename, holeNo, round(a));

b = round(a(:));

[n, bin] = hist(b, unique(b));
#[~,idx] = sort(-n);

#n(idx)
#bin(idx)

closestVal(600, bin)

return

    b = nonzeros(round(a(:)/5)*5);
    #c = a(:);
    
    [nb, binb] = hist(b, unique(b));
    [~,idxb] = sort(-nb);
    
    #[nc, binc] = hist(c, unique(c));
    #[~,idxc] = sort(-nc);
    
    roundedVal = binb(idxb(1));
    
    #{
    if abs(roundedVal - binc(idxc(1))) < 2.5
      closestVal = binc(idxc(1));
    else
      [~, idx] = min(abs(binc - roundedVal));
      closestVal = binc(idx);
    endif
    #}
    
printf("%s %d: %3.1f %3.1f %3.1f most popular (+/-2.5) %3.1f\n", basename, holeNo, min(min(a)), mean(mean(a)), max(max(a)), roundedVal);