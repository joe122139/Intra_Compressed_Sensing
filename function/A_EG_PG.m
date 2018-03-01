function result = A_EG_PG(u2,u1,r,q)
    c=1;
    for i=u1+1:u2
        a=power(q,r-i+1)-1;
        b=power(q,u2-i+1)-1;
        c=c*a/b;
    end
    result = c;
end