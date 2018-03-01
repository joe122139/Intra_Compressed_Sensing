r=2;
q=3;
[H col_wt row_wt] = generate_EG_iter(r,q);

isViolate = checkviolation(H,col_wt,row_wt);