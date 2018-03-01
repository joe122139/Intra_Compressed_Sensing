function [c] = m_coherence(m,n,col)

    max = 0;
    tmp = 0;
    for i=1:col
        for j=1:col
            tmp  = abs(m(:,i)'*n(:,j))/(norm(m(:,i))*norm(n(:,j)));
                if(tmp>max)
                    max = tmp;
            end          
        end
    end
    c = sqrt(col)*max;

end