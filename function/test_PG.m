 r = 3;
 q = 7;
[H col_wt row_wt] = generate_PG_iter(r,q);
%H = generate_EG_iter(m,s);

isViolate = checkviolation(H,col_wt,row_wt);
