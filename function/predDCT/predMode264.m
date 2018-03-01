function [ pred_y,code ] = predMode264( block_y,N,B_i,B_j,ave_yo,mode,pred_bot_y,pred_ri_y,sensM)
%PREDMODE264 この関数の概要をここに記述
%   詳細説明をここに記述
idx = [4,8,12,13,14,15,16];
result=[];
for i = 1:7
    v(1:n)=0;
    v(idx(i))=1;
    result(:,i) = sensM'\v';
end

n = N*N;
ni= zeros(9,1);


if (N==4)
    for k=1:12
        if(k<4)
            ni(k) = block_y(1:4,1,B_i,B_j-1)*result(:,k);
        elseif(k<8)
            ni(k) = block_y(1:4,1,B_i-1,B_j)*result(:,k);
        elseif (k==8)   % pixel h
            ni(k) = block_y(1:4,1,B_i,B_j-1)*result(:,7); 
        elseif (k==9)   %k==9  topleft pixel
            ni(k) = block_y(1:4,1,B_i-1,B_j-1)*result(:,7); 
        else
            ni(k) = block_y(1:4,1,B_i-1,B_j+1)*result(:,k-6); 
        end
    end
end

x = zeros(N);
switch pmode
    case 1  %vertical
        for k = 1:4
             x(k,1:4)=ni(4:7)' ;  %a
        end
    case 2 % horizontal
        for k = 1:3
             x(k,1:4)=ni(k) ;  %a
        end
             x(4,1:4)=ni(1:3) ;  %a
    case 4
        for k = 1:4
             x(k:k)= (ni(1)+ni(4)+2*ni(9)+2)/4;
             if(k<4)
                 x(k:k+1)= (ni(9)+ni(5)+2*ni(4)+2)/4;
                 x(k+1:k)= (ni(9)+ni(2)+2*ni(1)+2)/4;
             end
             if(k<3)
                 x(k:k+2)= (ni(4)+ni(6)+2*ni(5)+2)/4;
                 x(k+2:k)= (ni(1)+ni(3)+2*ni(2)+2)/4;
             end
         end
         x(1,4) =  (ni(5)+ni(7)+2*ni(6)+2)/4;
         x(4,1) =  (ni(8)+ni(2)+2*ni(3)+2)/4;
     case 5 % diagonal-right
         for k = 1:4
             x(k:k)= (ni(1)+ni(4)+2*ni(9)+2)/4;
             if(k<4)
                 x(k:k+1)= (ni(9)+ni(5)+2*ni(4)+2)/4;
                 x(k+1:k)= (ni(9)+ni(2)+2*ni(1)+2)/4;
             end
             if(k<3)
                 x(k:k+2)= (ni(4)+ni(6)+2*ni(5)+2)/4;
                 x(k+2:k)= (ni(1)+ni(3)+2*ni(2)+2)/4;
             end
         end
         x(1,4) =  (ni(5)+ni(7)+2*ni(6)+2)/4;
         x(4,1) =  (ni(8)+ni(2)+2*ni(3)+2)/4;
         
end

function [pred_y,code] = prop_pred ()
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
        if(leftBlk<topBlk)
            min_v = leftBlk;
            code=0;
            pred_y = pred_ri_y(:,1,B_i,B_j-1);                           
        else
            min_v = topBlk;
            code=1;
            pred_y = pred_bot_y(:,1,B_i-1,B_j);                            
        end              
    end
    
end

