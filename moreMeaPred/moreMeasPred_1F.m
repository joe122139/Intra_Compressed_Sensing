function [MSE,bit_per_frame,PSNR,coef,SSIM_] =...
    moreMeasPred_1F(A,SR,N,sensM,psi,cmp_mode,selM,Q_step, ...
pred_method,recon_method,imageName,DCTWT,id_bottom_r,id_right_c,takeLowF,isPrint)

path(path, './l1magic/Optimization');
path(path, './l1magic/');
path(path, './function/');
path(path,'./huffman/');%___INPUT IMAGE___
path(path, './SDPC_Code/Utilities/BCS-SPL-DPCM-1.0-2/');

file_y=fopen('./meas_pred/y.txt','w');
file_rec=fopen('./meas_pred/rec.txt','w');
file_resi = fopen('./meas_pred/resi.txt','w');
file_pred = fopen('./meas_pred/pred.txt','w');

[vidHeight,vidWidth] = size(A);
%___MEASUREMENT MATRIX___
rec =[];
dif =[];
n = N*N;
interv = round(N*SR);
m = N*interv;
errFcn      = @(a) norm(a-x)/norm(x);
zigzagInd= zigzag(N);

range = zigzagInd(1:m);

if(takeLowF)
    sensM_ = sensM(range,:);
else
    sensM_ = sensM(1:m,:);
end



bit_blocks =[];
code =[];
coef = [];
h_B = floor(vidHeight/N);
w_B = floor(vidWidth/N);

if(selM~=1)
    part_range = [1:m];
else
	part_range = [3:m];   
end

%id_bottom_r = 1;
%id_right_c = 2;
  midValue = 128;
  pred_bot_y = [];
  pred_ri_y = [];

  tmp =2;
  if(N==16)
      tmp =4;
  end
  buf_up = zeros(1,h_B*tmp)+midValue;
for B_i=1:h_B
   % B_i
    buf_le = [midValue midValue midValue midValue];
    for B_j=1:w_B
        
        h_be = (B_i-1)*N+1;
        h_ed = B_i*N;
        w_be = (B_j-1)*N+1;
        w_ed = B_j*N; 
        B = double(A(h_be:h_ed,w_be:w_ed));
        bb = dct2(B);
        thred =1;
        x =reshape(transpose(B),n,1);
        
        %___COMPRESSION___
        y = sensM_*x;          
        block_y(:,1,B_i,B_j)=y;
        
        if(selM==4 && isPrint)
          for i=1:m
            fprintf(file_y,'%d\t',y(i));
        end
        fprintf(file_y,' %d %d\n',B_j-1,B_i-1);
        end
        
        DC_block = zeros(n,1)+midValue;
      
        ave_yo = sensM_*DC_block;
     
        if(B_j==19 && B_i==2)
        end
        pred_y=[];
        if(selM==1 || selM==4)
            neigh = refPrepare(buf_up,buf_le,B_i,B_j,w_B,midValue,N);       
            [pred_y,code(B_i,B_j)] = propIntraPred (block_y,B_i,B_j,cmp_mode,ave_yo,sensM_,neigh,N);
            resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j) - pred_y;

        elseif(selM==2 )
            [pred_y,code(B_i,B_j)] = dir_pred(block_y,B_i,B_j,ave_yo,cmp_mode,pred_method,w_B);
            resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j) - pred_y;      
        else
            resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j)-ave_yo;
        end
        %Q
        if(selM ==3 )
            coef(B_i,B_j) = corr_coeff(ave_yo,y); 
        else
            coef(B_i,B_j) = corr_coeff(pred_y,y);
        end
 
        if(selM==1)
            resi_q(part_range,1,B_i,B_j)=bitshift(resi(part_range,1,B_i,B_j),-Q_step,'int64');
            resi_q(1:2,1,B_i,B_j)=resi(1:2,1,B_i,B_j);  %no Q for 1:2
        else         
            resi_q(:,1,B_i,B_j)=bitshift(resi(:,1,B_i,B_j),-Q_step,'int64');
        end
        
        
        MSE(:,1,B_i,B_j) = ary_SSE(resi_q(:,1,B_i,B_j));
        

        if(selM>2 && isPrint)
             for i=1:m
                    fprintf(file_resi,'%d\t',resi_q(i,1,B_i,B_j));
             end

            if(selM==4)  
                fprintf(file_resi,'%d\t%d\t%d\n',B_j-1,B_i-1,code(B_i,B_j));
                fprintf(file_pred,'%d\t%d\t%d\t%d\n',pred_y(1),B_j-1,B_i-1,code(B_i,B_j));
            else
                fprintf(file_resi,'\n');
            end 
           
       end
        %end of Enc.
        
        %decoder
       
            resi_q_d(part_range,1,B_i,B_j) = bitshift( resi_q(part_range,1,B_i,B_j),Q_step,'int64');
            if(selM==1)
                resi_q_d(1:2,1,B_i,B_j) =  resi_q(1:2,1,B_i,B_j);
            end
            
            % NOTE: Avoid calculating Psi (nxn) directly to avoid memory issues.
            if(selM==1 || selM==4)
                neigh = refPrepare(buf_up,buf_le,B_i,B_j,w_B,midValue,N);   
                pred_x = predModes(code(B_i,B_j),N,neigh);
                pred_y_dec = sensM_*pred_x';    
            elseif(selM==2)
                if(code(B_i,B_j)==-1)
                    pred(1:m,1) = ave_yo;
                elseif(code(B_i,B_j)==0)       %left
                    pred(1:m,1) = rec_y(:,1,B_i,B_j-1);
                elseif(code(B_i,B_j)==1)     %upper neighbor
                    pred(1:m,1) = rec_y(:,1,B_i-1,B_j);
                elseif(code(B_i,B_j)==2) 
                    pred(1:m,1) = bitshift((rec_y(:,1,B_i-1,B_j)+rec_y(:,1,B_i,B_j-1)+1),-1,'int64');
                else
                    pred(1:m,1) = rec_y(:,1,B_i-1,B_j-1);
                end
       
                pred_y_dec =  pred(1:m,1);
            else
                pred_y_dec = ave_yo;
            end

            y = resi_q_d(:,1,B_i,B_j) + pred_y_dec;
            rec_y(:,1,B_i,B_j) = y;     

       
            Theta = sensM_*psi;
            s2 = Theta'*y;

            %prediction

            %quantization
         if(selM>2 && isPrint)
            for i=1:m
                fprintf(file_rec,'%d\t',y(i));
            end
            fprintf(file_rec,'\t%d\t%d\n',B_j-1,B_i-1);
         end

            %%
        switch recon_method
         case 1
            epsilon = 3e-3;
            I = B;
            I = I/norm(I(:));
            I = I - mean(I(:));


            tvI = sum(sum(sqrt([diff(I,1,2) zeros(N,1)].^2 + [diff(I,1,1); zeros(1,N)].^2 )));
          %  s1 =  tvdantzig_logbarrier(x0, MeaM_, At, b, epsilon, 1e-3, 5, 1e-8, 1500);
     %      s1 =  tvdantzig_logbarrier(s2, Theta, Theta', y, epsilon, 1e-3, 5, 1e-8, 1500);
           s1 =  tvqc_logbarrier(s2, Theta, Theta', y, epsilon, 1e-3, 5, 1e-8, 200);
     % s1 =  tveq_logbarrier(s2, Theta, Theta', y, 1e-3, 5, 1e-8, 200);

            Ip = reshape(s1, N, N);   
            block(:,:,B_i,B_j) =   Ip;
            
            
        
        case 2
            epsilon = 3e-3;
            s1 = l1dantzig_pd(s2, Theta, Theta', y, epsilon, 5e-2);     % N
         case 3
            opts = [];
            opts.slowMode = 0;
            opts.printEvery     = 25;
           
            error = 1e-3;
            [s1] = OMP( Theta, y, error, errFcn,opts);
        end
            %___IMAGE RECONSTRUCTIONS___
            
            x1 = psi*s1;
           
            block(:,:,B_i,B_j) = transpose(reshape(x1,N,N));
            
     
        rec(h_be:h_ed,w_be:w_ed)= block(:,:,B_i,B_j);
        dif(:,1,B_i,B_j)= rec_y(:,1,B_i,B_j) - block_y(:,1,B_i,B_j);
        block_y(:,1,B_i,B_j) = rec_y(:,1,B_i,B_j);
       
        if(N==8)
            shiftVal = 2;
            bias = 2;
            buf_le(1:2) = bitshift(block_y(3:4,1,B_i,B_j)+bias,-shiftVal,'int64');
            buf_up(B_j*2-1:B_j*2) = bitshift(block_y(1:2,1,B_i,B_j)+bias,-shiftVal,'int64');
        elseif(N==16)
            shiftVal = 2;
            bias = 2;
            buf_le(1:4) = bitshift(block_y(5:8,1,B_i,B_j)+bias,-shiftVal,'int64');
            buf_up(B_j*4-3:B_j*4) = bitshift(block_y(1:4,1,B_i,B_j)+bias,-shiftVal,'int64');
        end

      
        

    end
end
total_pixels = h_B*w_B*m;
bit_per_frame = Measurement_Entropy(resi_q(:,1,:,:),total_pixels);
bit_per_frame = bit_per_frame + Measurement_Entropy(code(:,:),h_B*w_B)/n;
%bit_per_frame = 0;


PSNR = psnr((A(1:N*h_B,1:N*w_B)),uint8(rec(:,:)));
SSIM_ = ssim(double(rec(:,:)),double(A(1:N*h_B,1:N*w_B)));
%figure(Q_step*4+selM);
rec=rec-min(rec(:)); % shift data such that the smallest element of A is 0
rec=rec/max(rec(:)); % normalize the shifted data to 1 
%imshow(rec(:,:));
imwrite(rec(:,:),imageName);
imageName
%coherence(Theta,n)
 %miu = m_coherence(sensM,haargen(n)',n)
%block_m = block_y(:,1,:,:);
%block_m_rec = rec_y(:,1,:,:);
%bit_per_frame = mean(mean(bit_blocks));

fclose(file_rec);
fclose(file_y);
fclose(file_resi);
fclose(file_pred);




