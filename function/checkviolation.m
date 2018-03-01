function isViolate = checkviolation(H,col_wt,row_wt)
[h w] = size(H);
isViolate = 0;
    for i=1:h-1
        for k=i+1:h
            a=(H(i,:)+H(k,:));
            if(any(a(:)>2))
                display('row violates');
                isViolate =1;
            end
        end
    end

    for i=1:w-1
        for k=i+1:w
            b=(H(i,:)+H(k,:));
            if(any(b(:)>2))
                display('col violates');
                isViolate =2;
            end
        end
    end
    
    c_w = sum(H);
    r_w = sum(H,2);
    if(any(r_w(:)~=row_wt))
        display('row weight violates');
        isViolate =3;
    end

    if(any(c_w(:)~=col_wt))
        display('col weight violates');
        isViolate =4;
    end
end