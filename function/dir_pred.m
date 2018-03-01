function [pred_y,code] = dir_pred (block_y,B_i,B_j,ave_yo,mode,pred_method,w_B)
    switch pred_method
        case 1
        if(B_j>1 && B_i==1)     %1st row
            pred_y = block_y(:,1,B_i,B_j-1);   
            code=0;
        elseif(B_i>1 && B_j==1)  %1st col.
            pred_y =  block_y(:,1,B_i-1,B_j);  
            code=1;
        elseif(B_j>1 && B_i>1) %not 1st col. & 1st row      
            leftBlk_mea = array_compare(block_y(:,1,B_i,B_j-1),block_y(:,1,B_i,B_j),mode);
            topBlk_mea = array_compare(block_y(:,1,B_i-1,B_j),block_y(:,1,B_i,B_j),mode);     
            nonBlk = array_compare(0,block_y(:,1,B_i,B_j),mode); 
            if(leftBlk_mea<topBlk_mea) 
                min_v = leftBlk_mea;
                pred_y = block_y(:,1,B_i,B_j-1);       
                code=0;
            else
                min_v = topBlk_mea;
                pred_y =  block_y(:,1,B_i-1,B_j);
                code=1;
            end
             if(nonBlk<min_v)
                code=-1;
                pred_y =ave_yo;
            end
        else  % the block in 1st col. 1st row    not prediction at all      
            pred_y = ave_yo; 
            code=-1;               
          %   MSE_dir(:,1,B_i,B_j) = 0;
        end
        case 2        
            if(B_j>1 && B_i==1)     %1st row            
                pred_y = block_y(:,1,B_i,B_j-1);   
                code=0;
            elseif(B_i>1 && B_j==1)  %1st col.              
                pred_y =  block_y(:,1,B_i-1,B_j);  
                code=1;            
            elseif(B_j>1 && B_i>1) %not 1st col. & 1st row      
                leftBlk_mea = array_compare(block_y(:,1,B_i,B_j-1),block_y(:,1,B_i,B_j),mode);
                topBlk_mea = array_compare(block_y(:,1,B_i-1,B_j),block_y(:,1,B_i,B_j),mode);   
                if(B_i==2 && B_j==5)
                    
                end
                DC_blk_mea = array_compare(bitshift(block_y(:,1,B_i-1,B_j)+block_y(:,1,B_i,B_j-1),-1,'int64'),block_y(:,1,B_i,B_j),mode);   
                Dia_mea = array_compare(block_y(:,1,B_i-1,B_j-1),block_y(:,1,B_i,B_j),mode);                       
                min_v = leftBlk_mea;
                pred_y = block_y(:,1,B_i,B_j-1);       
                code=0;          
                if(topBlk_mea<min_v) 
                    min_v = topBlk_mea;
                    pred_y =  block_y(:,1,B_i-1,B_j);
                    code=1;
                end
                if(DC_blk_mea<min_v) 
                    min_v = DC_blk_mea;
                    code=2;
                    pred_y =bitshift((block_y(:,1,B_i-1,B_j)+block_y(:,1,B_i,B_j-1)),-1,'int64');
                end
                if(Dia_mea<min_v)
                    min_v = Dia_mea;
                    code=3;
                    pred_y = block_y(:,1,B_i-1,B_j-1);
                end      
            
            else  % the block in 1st col. 1st row    not prediction at all      
                pred_y = ave_yo; 
                code=-1;               
              %   MSE_dir(:,1,B_i,B_j) = 0;
            end
       %{
 case 3
             if(B_j>1 && B_i==1)     %1st row
                pred_y = block_y(:,1,B_i,B_j-1);   
                code=0;
            elseif(B_i>1 && B_j==1)  %1st col.
                pred_y =  block_y(:,1,B_i-1,B_j);  
                code=1;
            elseif(B_j>1 && B_i>1) %not 1st col. & 1st row      
                leftBlk_mea = array_compare(block_y(:,1,B_i,B_j-1),block_y(:,1,B_i,B_j),mode);
                topBlk_mea = array_compare(block_y(:,1,B_i-1,B_j),block_y(:,1,B_i,B_j),mode);   
                Dia_mea = array_compare(block_y(:,1,B_i-1,B_j-1),block_y(:,1,B_i,B_j),mode);
                topR_blk_mea=0;
                if(B_j~= w_B)
                    topR_blk_mea = array_compare(block_y(:,1,B_i-1,B_j+1),block_y(:,1,B_i,B_j),mode);
                end
                nonBlk = array_compare(0,block_y(:,1,B_i,B_j),mode); 
              
                min_v = leftBlk_mea;
                pred_y = block_y(:,1,B_i,B_j-1);       
                code=0;
                if(topBlk_mea<min_v) 
                    min_v = topBlk_mea;
                    pred_y =  block_y(:,1,B_i-1,B_j);
                    code=1;
                end
                if(Dia_mea<min_v)
                    min_v = Dia_mea;
                    code=3;
                    pred_y = block_y(:,1,B_i-1,B_j-1);
                end
                if(topR_blk_mea<min_v &&  B_j~= w_B)
                    min_v = topR_blk_mea;
                    code=2;
                    pred_y = block_y(:,1,B_i-1,B_j+1);
                end
                if(nonBlk<min_v)
                    code=-1;
                    pred_y =ave_yo;
                end
            
            else  % the block in 1st col. 1st row    not prediction at all      
                pred_y = ave_yo; 
                code=-1;               
              %   MSE_dir(:,1,B_i,B_j) = 0;
            end
            %}
    end
end