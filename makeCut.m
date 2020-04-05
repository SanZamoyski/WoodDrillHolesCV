basenames = {"3W9X"; "3W9Y"; "3M9X"; "3M9Y"; "3H9X"; "3H9Y"};

tic

for sample=1:size(basenames)(1)
  printf("%s: ", basenames{sample});
  cutForSamples(basenames{sample});
  toc
endfor
