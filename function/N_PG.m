function result = N_PG(u2,u1,r,q)
    c=1;
    for i=0:u1
        a=power(q,u2-i+1)-1;
        b=power(q,u1-i+1)-1;
        c=c*a/b;
    end
    result = c;
end