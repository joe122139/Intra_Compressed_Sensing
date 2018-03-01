function result = N_EG(u2,u1,r,q)
    Q=power(q,u2-u1);
    c=1;
    for i=1:u1
        a=power(q,u2-i+1)-1;
        b=power(q,u1-i+1)-1;
        c=c*a/b;
    end
    result = Q*c;
end