%%Projective Geometry Matrix
function H = generate_PG(m,s)
    wd_H = (power(2,(m+1)*s)-1)/(power(2,s)-1);
    idx1= [m*s:-s:s];
    idx2 = [(m-1)*s:-s:s];
    
    p2_idx1 = power(2,idx1);
    p2_idx2 = power(2,idx2);
    
    ht_H = (sum(p2_idx1)+1)*(sum(p2_idx2)+1)/(power(2,s)+1);
    
    
  
    
    
    col_wt = (power(2,m*s)-1)/(power(2,s)-1);
    row_wt = power(2,s)+1;
%{
    wd_H = q*q+q+1;
    ht_H = q*q+q+1;
    col_wt =q+1;
    row_wt = q+1;
%}
    
    global flag_row;
    global flag_col;
    global col_wt_rest;
    global row_wt_rest;
    global H;
    H = zeros(ht_H,wd_H);
    find = 0;
    col_wt_rest = ones(1,wd_H).*col_wt;
    row_wt_rest = ones(1,ht_H).*row_wt;
    flag_row = zeros(ht_H,ht_H);
    flag_col = zeros(wd_H,wd_H);
    flag_row(1,:) =1;
    flag_col(1,:) =1;
    goDeeper_Ele(1,ht_H,wd_H);
    H;
    %{
    for i=1:ht_H;
       [find]=goDeeper(i,1,wd_H,row_wt);
       if(~find)
           display('fail');
           break;
       end
    end
%}
end


function [b_find] = goDeeper(i,j,n,row_wt)
    global flag_row;
    global flag_col;
    global H;
    global col_wt_rest;
    if(row_wt==0)   %to the end of i,j
        b_find = 1;
       
    else 
        if(j>n && row_wt>0)
            b_find= 0;
        else
          if(check_condition(i,j) && col_wt_rest(j)~=0)
              H(i,j) = 1;
              col_wt_rest(j)= col_wt_rest(j)-1;
              mark(i,j);
              [b_find] = goDeeper(i,j+1,n,row_wt-1);
              if(~b_find)
                  H(i,j) = 0;
                  mark(i,j);
                  col_wt_rest(j)= col_wt_rest(j)+1;
                  b_find=goDeeper(i,j+1,n,row_wt);
              end
          else
              b_find=goDeeper(i,j+1,n,row_wt);
          end
        end
    end
     
end

function [b_find] = goDeeper_Ele(idx,m,n,row_wt)
    global flag_row;
    global flag_col;
    global H;
    global col_wt_rest;
    global row_wt_rest;
    i = floor((idx-1) / n)+1;   
    j = mod(idx-1,n)+1;

    if(idx>m*n)   %to the end of i,j
        
        if(sum(row_wt_rest)==0 && sum(col_wt_rest)==0)
            b_find = 1;
        else
            b_find = 0;
        end
    else 
        if(j>n && row_wt_rest(i)>0)
            b_find= 0;
        else
          if(check_condition(i,j) && col_wt_rest(j)~=0 && row_wt_rest(i)~=0)
              H(i,j) = 1;
              col_wt_rest(j)= col_wt_rest(j)-1;
              row_wt_rest(i)= row_wt_rest(i)-1;
              mark(i,j);
              [b_find] = goDeeper_Ele(idx+1,m,n);
              if(~b_find)
                  H(i,j) = 0;
                  mark(i,j);
                  col_wt_rest(j)= col_wt_rest(j)+1;
                  row_wt_rest(i)= row_wt_rest(i)+1;
                  b_find=goDeeper_Ele(idx+1,m,n);
              end
          else
              b_find=goDeeper_Ele(idx+1,m,n);
          end
        end
    end
     
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
