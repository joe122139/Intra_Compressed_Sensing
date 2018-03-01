function [pred_y,code] = prop_pred (block_y,B_i,B_j,ave_yo,mode,pred_bot_y,pred_ri_y)
   if(B_i==10&& B_j==27)
   end
nonBlk = array_compare(ave_yo,block_y(:,1,B_i,B_j),mode); 
    pred_y = ave_yo;               
    code=-1; %  default is use original
    if(B_j>1 && B_i==1)     %1st row
        leftBlk = array_compare(pred_ri_y(:,1,B_i,B_j-1),block_y(:,1,B_i,B_j),mode);
        if(leftBlk<nonBlk)
            pred_y = pred_ri_y(:,1,B_i,B_j-1);               
            code=0; % use left
        end
    elseif(B_i>1 && B_j==1)  %1st col.
        topBlk = array_compare(pred_bot_y(:,1,B_i-1,B_j),block_y(:,1,B_i,B_j),mode);             
        if(topBlk<nonBlk)
           pred_y = pred_bot_y(:,1,B_i-1,B_j);          
            code=1; % use left
        end
    elseif(B_j>1 && B_i>1) %not 1st col. & 1st row
        leftBlk = array_compare(pred_ri_y(:,1,B_i,B_j-1),block_y(:,1,B_i,B_j),mode);
        topBlk = array_compare(pred_bot_y(:,1,B_i-1,B_j),block_y(:,1,B_i,B_j),mode);            
        if(leftBlk<topBlk && leftBlk<nonBlk)
            min_v = leftBlk;
            code=0;
            pred_y = pred_ri_y(:,1,B_i,B_j-1);                           
        elseif(topBlk<nonBlk)
            min_v = topBlk;
            code=1;
            pred_y = pred_bot_y(:,1,B_i-1,B_j);            
        else
            min_v = nonBlk;
             code=-1;
             pred_y= ave_yo;
        end              
    end
 
end