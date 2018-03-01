function M = subMatrix(p,m)
    M = zeros(p,p);
    for y = 0:p-1
        for x = 0:p-1 
            if(x == mod(y+m,p))
                M(y+1,x+1)=1;
            end
        end
    end
end
