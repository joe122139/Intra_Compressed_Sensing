function [ bottom right ] = cal_aver_predDCT( block_y,B_i,B_j,N,MAT_idx,SR)
%CAL_AVER_PREDDCT ‚±‚ÌŠÖ”‚ÌŠT—v‚ð‚±‚±‚É‹Lq
%   Calculate the aver_bottom row and aver_right column of
%   block_y(B_i,B_j). N is the size of block_y. Block_y conists of
%   measuremments.
bot=0;
ri= 0;
%val  = [];
val = block_y(:,1,B_i,B_j);
   switch N
       case 4
     %       v14 = val(1)+val(4)
            if(B_i==110 & B_j==1)
            
            end
          %      B_i
    %        B_j
            %bitshift(v14,-1)
             bot = bitshift(bitshift(val(1)+val(4),-1,'int64')-val(3),-1,'int64');
             if(SR>=0.5)
             ri = bitshift(bitshift(val(1)+val(6),-1,'int64')-val(2),-1,'int64');
             end
             
       case 8     
           if(MAT_idx==4)   %SR>=0.15
               bot = bitshift(bitshift(bitshift(val(1)+val(11)+1,-1,'int64')+val(4)+1,-1,'int64')-val(10)+1,-1,'int64');    %( ((v1+v11+1>>1)+v4+1)>>1-v10+1)>>1  <--> v1*0.125+v11*0.125+v4*0.025-v10*0.5
               ri = bitshift(bitshift(bitshift(val(1)+val(15)+1,-1,'int64')+val(6)+1,-1,'int64')-val(7)+1,-1,'int64');    %( ((v1+v15+1>>1)+v6+1)>>1-v7+1)>>1  <--> v1*0.125+v15*0.125+v6*0.025-v7*0.5
   
           end
           
       case 16
           if(MAT_idx==2)
                bot = bitshift(bitshift(bitshift(val(1)-val(3)-val(21)+val(37),-1,'int64')+val(11)-val(10),-1,'int64')+val(4)-val(105),-2,'int64');    %(((v1-v3-v21+v37)>>1)+v11-v10)>>1-v105+v4)))>>2          
                ri =    bitshift(bitshift(bitshift(val(1)-val(2)-val(16)+val(45),-1,'int64')+val(15)-val(7),-1,'int64')+val(6)-val(92),-2,'int64');
           end
   end
        

   
   bottom= bitshift(bot,-log2(N),'int64');
  right = bitshift(ri,-log2(N),'int64');

end

