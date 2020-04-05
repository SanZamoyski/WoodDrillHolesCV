basename = "3H9Y";
holeNo = 4;

printf("Samp No Min Mean Max\n") 

a = holeHoughTester(basename, holeNo, true);


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