%%Euclidean Geometry Matrix
function H = generate_EG(m,s)
    m = 2; 
    s = 2;
    wd_H = power(2,m*s)-1;
    ht_H = power(2,(m-1)*s)*(power(2,m*s)-1)/(power(2,s)-1);
    col_wt = (power(2,m*s)-1)/(power(2,s)-1)-1;
    row_wt = power(2,s);
    
    A = gf(3,2)
    A = gf(ones(4,1)*[0 1 2 3],2);
    B = gf([0 1 2 3]'*ones(1,4),2);
C=A+B
end
