%{
# of cols:   wd_H= 2^(ms)-1
# of rows: ht_H = (2^((m-1)*s)-1)*(2^(ms)-1)/(2^s-1)
weight_col:  
%}
function [H col_wt row_wt]= generate_EG_iter(r,q)
    u2=1;   %u2-flat =1   line
    u1=0;   %U1-flat = 0   point
    wd_H = N_EG(r,u1,r,q);
    ht_H = N_EG(r,u2,r,q);
    col_wt = A_EG_PG(u2,u1,r,q);
    row_wt = N_EG(u2,u1,r,q);

    global flag_row;
    global flag_col;
    global col_wt_rest;
    global row_wt_rest;
    global H;
    H = zeros(ht_H,wd_H);
    find = 0;
    col_wt_rest = ones(1,wd_H).*col_wt;
    row_wt_rest = ones(1,ht_H).*row_wt;
    flag_row = zeros(ht_H,ht_H);
    flag_col = zeros(wd_H,wd_H);
    flag_row(1,:) =1;
    flag_col(1,:) =1;
    iter_Ele(ht_H,wd_H);
  
end