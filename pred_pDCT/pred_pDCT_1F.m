function [MSE,bit_per_frame,PSNR,coef,SSIM_] =...
    pred_pDCT_1F(A,SR,N,sensM,psi,mode,selM,Q_step, ...
pred_method,recon_method,imageName,DCTWT,takeLowF,DCTMAT,isPrint)

path(path, './l1magic/Optimization');
path(path, './l1magic/');
path(path, './function/');
path(path, './function/predDCT');
path(path,'./huffman/');%___INPUT IMAGE___
path(path, './SDPC_Code/Utilities/BCS-SPL-DPCM-1.0-2/');

file_y=fopen('./pred_pDCT/y.txt','w');
file_rec=fopen('./pred_pDCT/rec.txt','w');
file_resi = fopen('./pred_pDCT/resi.txt','w');
file_pred = fopen('./pred_pDCT/pred.txt','w');

[vidHeight,vidWidth] = size(A);
%___MEASUREMENT MATRIX___
rec =[];
rec_y = [];
org_B=[];
s1_= [];
array_s1 =[];
n = N*N;



interv = round(N*SR);
m = round(N*N*SR);
errFcn      = @(a) norm(a-x)/norm(x);
zigzagInd= zigzag(N);

range = zigzagInd(1:m);

%if(takeLowF)
%   sensM_ = sensM(range,:);
%else
%    sensM_ = sensM(1:m,:);
%end



bit_blocks =[];

coef = [];
h_B = floor(vidHeight/N);
w_B = floor(vidWidth/N);
code=zeros(h_B,w_B);
if(selM~=1)
    part_range = [1:m];
else
	part_range = [3:m];   
end

%id_bottom_r = 1;
%id_right_c = 2;
  pred_bot_y = [];
  pred_ri_y = [];

for B_i=1:h_B
   % B_i
    for B_j=1:w_B

      %  if(B_i==3 && B_j >6 && B_j<10)
      %      m = 12;
      %  end
        if(takeLowF)
            sensM_ = sensM(range,:);
        else
            sensM_ = sensM(1:m,:);
        end
        h_be = (B_i-1)*N+1;
        h_ed = B_i*N;
        w_be = (B_j-1)*N+1;
        w_ed = B_j*N; 
        B = double(A(h_be:h_ed,w_be:w_ed));
 %       bb = dct2(B);
%        thred =1;
%        F = find(bb<thred & bb>-thred);
        x =reshape(transpose(B),n,1);
        
        %___COMPRESSION___
        y = sensM_*x;  
        %y (find(abs(y)<20))=0;
        
        block_y(:,1,B_i,B_j)=y;
        
        if(isPrint) 
            for i=1:m
                fprintf(file_y,'%d\t',y(i));
            end
            fprintf(file_y,' %d %d\n',B_j-1,B_i-1);
        end
        %dlmwrite('./pred_pDCT/y.txt',y','delimiter', '\t','-append');
        
         array_s1(B_i,B_j,:)= y;   %Bi:x,  Bj:y
      %  B_j
        
        DC_block = ones(n,1)*128;
      
        ave_yo = sensM_*DC_block;
     
       pred_y=[];
        if(selM==1 || selM==4)
                   
            [pred_y,code(B_i,B_j)] = prop_pred (block_y,B_i,B_j,ave_yo,mode,pred_bot_y,pred_ri_y);
            resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j) - pred_y;
            %prediction ---            
            %  --- Quantization 
            
        elseif(selM==2 )
            [pred_y,code(B_i,B_j)] = dir_pred(block_y,B_i,B_j,ave_yo,mode,pred_method,w_B);
            resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j) - pred_y;      
        else
            resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j)-ave_yo;
           % resi(:,1,B_i,B_j) = block_y(:,1,B_i,B_j);
        end
        %Q
        if(selM ==3 )
            coef(B_i,B_j)=corr_coeff(ave_yo,y); 
        else
            coef(B_i,B_j) =corr_coeff(pred_y,y);
        end
 
        if(selM==1)
            resi_q(part_range,1,B_i,B_j) = floor(bitsra(resi(part_range,1,B_i,B_j),Q_step));        
            resi_q(1:2,1,B_i,B_j)=resi(1:2,1,B_i,B_j);  %no Q for 1:2
        else
            resi_q(:,1,B_i,B_j) = floor(bitsra(resi(:,1,B_i,B_j),Q_step));  
        end
        
         if(isPrint)
            for i=1:m
                fprintf(file_resi,'%d\t',resi_q(i,1,B_i,B_j));
            end
          %  fprintf(file_resi,'\n');

   
          fprintf(file_resi, '%d\n',code(B_i,B_j));
        end
  %          if(B_j>1 )
                     
  %              fprintf(file_resi,'%d\t%d\t%d\n',B_j-1,B_i-1,code(B_i,B_j));
              
    %        end
        MSE(:,1,B_i,B_j) = ary_SSE(resi_q(:,1,B_i,B_j));
         fprintf(file_pred,'%d\t%d\t%d\t%d\n',pred_y(1),B_j-1,B_i-1,code(B_i,B_j));

        

        %end of Enc.
        
        %decoder
       
        
       
            
            resi_q_d(part_range,1,B_i,B_j) =  bitsll(resi_q(part_range,1,B_i,B_j),Q_step);
            if(selM==1)
                resi_q_d(1:2,1,B_i,B_j) =  resi_q(1:2,1,B_i,B_j);
            end
            
            % NOTE: Avoid calculating Psi (nxn) directly to avoid memory issues.
            if(selM==1 || selM==4)
                if( code(B_i,B_j)==0)            
                    [left_bot left_right]=cal_aver_predDCT( rec_y,B_i,B_j-1,N,DCTMAT,SR);
                    pred_x(1:n,1) = left_right;
                elseif(code(B_i,B_j)==1)
                     [up_bot up_right]=cal_aver_predDCT( rec_y,B_i-1,B_j,N,DCTMAT,SR);
                    pred_x(1:n,1) = up_bot;
                end   
                %sensM_*pred_x(1:n)

                if(code(B_i,B_j)~=-1)
                    pred_y_dec = sensM_*pred_x(1:n,1);    
                else
                    pred_y_dec = ave_yo;
                end
            elseif(selM==2 )
                
                if(code(B_i,B_j)==-1)
                    pred(1:m,1) = ave_yo;
                elseif(code(B_i,B_j)==0)       %left
                    pred(1:m,1) = rec_y(:,1,B_i,B_j-1);
                elseif(code(B_i,B_j)==1)     %upper neighbor
                    pred(1:m,1) = rec_y(:,1,B_i-1,B_j);
                elseif(code(B_i,B_j)==2) 
                    pred(1:m,1) = bitshift(rec_y(:,1,B_i-1,B_j)+rec_y(:,1,B_i,B_j-1)+1,-1,'int64');    %./2
                else
                    pred(1:m,1) = rec_y(:,1,B_i-1,B_j-1);
                end
       
                pred_y_dec =  pred(1:m,1);
            else
                pred_y_dec = ave_yo;
            end
       
      %      pred_y_dec
      %      resi_q_d(:,1,B_i,B_j)
       %     code(B_i,B_j)
            y = resi_q_d(:,1,B_i,B_j) + pred_y_dec;
            rec_y(:,1,B_i,B_j) = y;     
            
            if(isPrint)
                for i=1:m
                    fprintf(file_rec,'%d\t',y(i));
                end
                fprintf(file_rec,'\t%d\t%d\n',B_j-1,B_i-1);
            end
            % dlmwrite('./pred_pDCT/rec.txt',y','delimiter', '\t','-append');

            %fprintf(file_rec,'%d',y);
       
            Theta = sensM_*psi;
          %  Theta = sensM_;
            s2 = Theta'*y;

            %prediction

            %quantization


            
            
            
            
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

             if(B_i==4)
    %             figure(B_j)
             
    %               scatter(1:m,y)            
             end
         %  array_s1(B_i,B_j,:)= s1_;   %Bi:x,  Bj:y
            block(:,:,B_i,B_j) = transpose(reshape(x1,N,N));
            
     
        rec(h_be:h_ed,w_be:w_ed)= block(:,:,B_i,B_j);
        block_y(:,1,B_i,B_j) = rec_y(:,1,B_i,B_j);
        
        %aver_bot(B_i,B_j) = round(block_y(id_bottom_r,1,B_i,B_j)/N);
        %aver_ri(B_i,B_j) = round(block_y(id_right_c,1,B_i,B_j)/N);
   %     B_i
    %    B_j
        if(B_i==2)
            
        end
        if(selM==4)
            [aver_bot(B_i,B_j)  aver_ri(B_i,B_j)]  = cal_aver_predDCT(block_y,B_i,B_j,N,DCTMAT,SR);

            %     [pred_bot_x(1:n,1,B_i,B_j) pred_ri_x(1:n,1,B_i,B_j)] = code(B_i,B_j)
            pred_bot_x(1:n,1,B_i,B_j) = aver_bot(B_i,B_j);
            pred_ri_x(1:n,1,B_i,B_j) = aver_ri(B_i,B_j);


            pred_bot_y(:,1,B_i,B_j) = sensM_*pred_bot_x(:,1,B_i,B_j);
            pred_ri_y(:,1,B_i,B_j) = sensM_*pred_ri_x(:,1,B_i,B_j);
            end
    end
end
total_pixels = h_B*w_B*m;
bit_per_frame = Measurement_Entropy(resi_q(:,1,:,:),total_pixels);
bit_per_frame = bit_per_frame + Measurement_Entropy(code(:,:),h_B*w_B)/n;
%    bit_per_frame = aver_bit_huffman_array(reshape(resi_q(:,1,:,:)+sft,h_B*w_B*m,1));



PSNR = psnr(A(1:N*h_B,1:N*w_B),rec(:,:));
SSIM_ = ssim(double(rec(:,:)),double(A(1:N*h_B,1:N*w_B)));
%figure(Q_step*4+selM);
rec=rec-min(rec(:)); % shift data such that the smallest element of A is 0
rec=rec/max(rec(:)); % normalize the shifted data to 1 
imshow(rec(:,:));
imwrite(rec(:,:),imageName);
imageName

fclose(file_rec);
fclose(file_y);
fclose(file_resi);
fclose(file_pred);

% 
% array_s1
% ary_s1_fnt10(:,:,1)=array_s1(:,:,1)./array_s1(:,:,2);
% ary_s1_fnt10(:,:,2)=array_s1(:,:,1)./array_s1(:,:,3);
% ary_s1_fnt10(:,:,3)=array_s1(:,:,1)./array_s1(:,:,4);
% ary_s1_fnt10(:,:,4)=array_s1(:,:,1)./array_s1(:,:,5);
% 
% figure(2);
% 
% z  = ary_s1_fnt10(:,:,1);
% 
% [x,y] = meshgrid(1:h_B,1:w_B);
% %surf(x,y,z);
% 
% surf(y,x,ary_s1_fnt10(:,:,1));
% %zlim([0 3000]);
% xlabel('B_i');
% ylabel('B_j');
% figure(3);
% surf(y,x,ary_s1_fnt10(:,:,2));
% figure(4);
% surf(y,x,ary_s1_fnt10(:,:,3));
% figure(5);
% surf(y,x,ary_s1_fnt10(:,:,4));
% 
% figure(6);
% surf(y,x,array_s1(:,:,2));
% xlabel('B_i');
% ylabel('B_j');
% 
% 
% figure(7);
% [x,y] = meshgrid(1:h_B,1:w_B);
% surf(y,x,z);
% 
% array_s1

%len(B_i,B_j) = length(F)
%coherence(Theta,n)
 %miu = m_coherence(sensM,haargen(n)',n)
%block_m = block_y(:,1,:,:);
%block_m_rec = rec_y(:,1,:,:);
%bit_per_frame = mean(mean(bit_blocks));





