function [c] = coherence(m,col)

    max = 0;
    tmp = 0;
    for i=1:col
        for j=1:col
            if(i~=j)
                tmp  = abs(m(:,i)'*m(:,j))/(norm(m(:,i))*norm(m(:,j)));
                if(tmp>max)
                    max = tmp;
            end          
        end
    end
    c = max;

end