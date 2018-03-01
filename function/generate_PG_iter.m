%%Projective Geometry Matrix
function [H col_wt row_wt] = generate_PG_iter(r,q)
    u2=1;   %u2-flat =1   line
    u1=0;   %U1-flat = 0   point
    wd_H = N_PG(r,u1,r,q);
    ht_H = N_PG(r,u2,r,q);
    col_wt = A_EG_PG(u2,u1,r,q);
    row_wt = N_PG(u2,u1,r,q);
%{ 
    wd_H = (power(2,(m+1)*s)-1)/(power(2,s)-1);
    idx1= [m*s:-s:s];
    idx2 = [(m-1)*s:-s:s];
    
    p2_idx1 = power(2,idx1);
    p2_idx2 = power(2,idx2);
    
    ht_H = (sum(p2_idx1)+1)*(sum(p2_idx2)+1)/(power(2,s)+1);
       
    col_wt = (power(2,m*s)-1)/(power(2,s)-1);
    row_wt = power(2,s)+1;
   
    m=2;
    q=3;
    
    wd_H = q*q+q+1;
    ht_H = q*q+q+1;
    col_wt =q+1;
    row_wt = q+1;
    %}
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

