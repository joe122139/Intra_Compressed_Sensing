function H = parity_check_Matrix(r,q,type)


    I = eye(q);
    P=circshift(I,-1);
    
    step = 1;
    o=1:step:r;j=1:q;
 
 switch type
    case 'PAC'
        i = o;  %Proper array code
    case 'IAC'
        i=mod(2.^(o-1),q);
end

    idx=i'*j;
    for i=1:r
        for j=1:q
            if(i==1 || j==1)
                subM(:,:,i,j) = I;
            else
                subM(:,:,i,j) = P^idx(i-1,j-1);  
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

