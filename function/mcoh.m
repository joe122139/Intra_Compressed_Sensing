function mu = mcoh(A,B,n) % 
%
max = -1;
for j=1:n
    for k=1:n
        bb = abs(dot(A(:,j),B(:,k)));
        if (bb>max)
            max = (bb);
        end
    end
end

mu = max;