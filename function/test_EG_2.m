
q=5;
%H = generate_EG_iter(m,s);
H = generate_EG_iter_2(q);
    col_wt = q+1;
    row_wt = q;

isViolate = checkviolation(H,col_wt,row_wt);