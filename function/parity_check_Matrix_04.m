%{
The method of creating parity check matrix is from the paper "quasi-cyclic
LDPC from circulant permutation matrices ", by Marc P.C. Fossorier
%}

function H = parity_check_Matrix_04(r,q,p)
%%
  type = 'product';
    switch type
        case 'product'
            a = 1:r;
            b = 1:q;
        case 'power'
            
    end
    m = a'*b;

for j= 1:r-1
    for l = 1:q-1
        P(:,:,j,l) = subMatrix(p,m(j,l));
    end
end

    I = eye(p);
    
    for i=1:r
        for k=1:q
            if(i==1 || k==1)
                subM(:,:,i,k) = I;
            else
                subM(:,:,i,k) = P(:,:,i-1,k-1);  
            end
        end
    end
    B=arrayfun(@(j) subM(:,:,:,j),1:q,'uni',0);
    C=cell2mat(B);
    D = squeeze(C);
    E=[];
    for i=1:r
        E = cat(2,E,D(:,:,i)');
    end
    H = E';
    
end


