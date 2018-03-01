
function [b_find] = iter_Ele(m,n)
    global H;
    global col_wt_rest;
    global row_wt_rest;
    s = CStack();
    idx = 1;
    cnt =1;
    while(idx<=m*n)
        cnt = cnt+1;
        i = floor((idx-1) / n)+1;   
        j = mod(idx-1,n)+1;
     %   if(cnt==52)
        if(mod(cnt,10000)==0)
  %     if(i==9 & j==8)
             cnt
             i
             j
        end
        if(col_wt_rest(j)<=m-i+1 && row_wt_rest(i)<=n-j+1)
            if(check_condition(i,j) && col_wt_rest(j)>0 && row_wt_rest(i)>0)
              H(i,j) = 1;
              col_wt_rest(j)= col_wt_rest(j)-1;
              row_wt_rest(i)= row_wt_rest(i)-1;
              mark(i,j);
              s.push([idx]);
            end
        end
        if(col_wt_rest(j)>m-i || row_wt_rest(i)>n-j)
            [idx]=s.pop();   
            i = floor((idx-1) / n)+1;   
            j = mod(idx-1,n)+1;
            H(i,j)  = 0;
            mark(i,j);
            col_wt_rest(j)= col_wt_rest(j)+1;
            row_wt_rest(i)= row_wt_rest(i)+1;         
            if(j==n)    %% if the idx popped just now is the last one in a row, pop again.
                [idx]=s.pop();   
                i = floor((idx-1) / n)+1;   
                j = mod(idx-1,n)+1;
                H(i,j)  = 0;
                mark(i,j);
                col_wt_rest(j)= col_wt_rest(j)+1;
                row_wt_rest(i)= row_wt_rest(i)+1;       
            end
        end
        idx = idx+1;     
    end
     b_find = 1; 
     cnt
end

function isPass = check_condition(cur_i,cur_j)
    global flag_row;
    global flag_col;
    global H;
    isPass = 1;
    for k=1:cur_i-1
        if(flag_row(cur_i,cur_i-k)==1 && H(cur_i-k,cur_j)==1)
            isPass= 0;
            break;
        end
    end

    for k=1:cur_j-1
        if(flag_col(cur_j,cur_j-k)==1 && H(cur_i,cur_j-k)==1)
             isPass= 0;
             break;
        end
    end
 
end

function b = mark(i,j)
    global flag_row;
    global flag_col;
    global H;
     for k=1:i-1
        if(H(k,j)==1 && H(i,j)==1)
            flag_row(i,k) = 1;
        else
            flag_row(i,k) = 0;
        end
        
     end
        for k=1:j-1
        if(H(i,k)==1 && H(i,j)==1)
            flag_col(j,k) = 1;
        else
            flag_col(j,k) = 0;
        end
     end
end