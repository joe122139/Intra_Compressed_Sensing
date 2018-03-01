%encode and decode a video with modified sensing matrix.
clear, close all, clc

path(path, './l1magic/Optimization');
path(path, './l1magic/');
path(path, './function/');
path(path, './l1magic/YUV2Image');
path(path, './16');
path(path, './image');


%A = A([50:50+N-1],[50:50+N-1]);



%  vidHeight = 288;   %# The image height
%  vidWidth = 352;    %# The image width\
vidHeight = 256;   %# The image height
vidWidth = 256;    %# The image width\
startF = 1;
nFrames = 1;
%dir = 'H:data\HEVC_SEQ\'; 
dir = 'G:SEQ\'; 
vname = 'FOOTBALL_352x288_30_orig_01';
fullname = strcat(dir,vname,'.yuv');
%mov = loadFileYuv_(fullname,vidWidth,vidHeight,startF:startF+nFrames,vidWidth);  %# Read the file

elapsedTime=[];
mode = 0;   %1:MSE   0: SAD
val_MSE =[];
bits =[];
block_m = [];
block_m_rec = [];
coff_ary=[];
rec_y_cmp = [];
inc= 1;
Q_step_st =2;
n_Q_step = 2;
n_selM = 4;
sel_st = 4;
fixLength = 12;
    isPrint =1;

co = [];
mean_corcof =[];
var_corcof =[];
SSIM=[];
    %per_oneInRow = 0.043;
%while 1
cnt =1;
%per_oneInRow = 0.0074;
%while 1

PSNR =[];
clip =0;
pred_method = 2;
%0.04305        l1_pd

mat_type = 1;
switch mat_type
    case 1
        type='z';  %binary 0/1
    case 2
        type = 'm'; %binary -1/1
    case 3
        type ='t';  %trinary -1/0/1
end

rec_method =2;
switch rec_method
    case 1
        recon_method =1;    %tvqc_logbarrier
        rm = 'tvqcL';
    case 2
        recon_method =2;    %l1dantzig_pd
        rm = 'l1PD';
    case 3
        recon_method =3;
        rm ='OMP';
end


N=16;
n = N*N;
dctdwt = 1;
psi = [];
switch dctdwt
    case 1       
        ctwt = 'dct';
        psi = dctmtx(n)';
    %    psi = dct2(eye(n));
    case 2  
         ctwt = 'dwt';
         psi = haargen(n)';
end


one_per= 0;
switch N
    case 4 
        one_per = 0.74;
    case 8
        one_per = 0.23;
    case 16
         one_per =0.04305;% 0.04415;%
    case 32
        one_per = 0.0074;
end

pDCT = 1;
isRand = 1;
DCTMAT = 0
for takeLowF =1:1
if(pDCT)
    isRand = 0;
  %  takeLowF = 1;
    one_per = 0;
end
SR=[0.75 0.6 0.5 0.4 0.3    0.25 0.2 0.1 0.05 0.01    1];
%___MEASUREMENT MATRIX___

 n_exp =  n_selM-sel_st+1;
 dctMat_type ='';
% for DCTMAT =1:3
 if (pDCT)
     DCTMAT =1;
     switch N
         case 4
            switch DCTMAT
                case 1                     
                    dctMat_type = '2013_A';
                case 2                     
                    dctMat_type = '2013_B';
            end
         case 8
             switch DCTMAT
                 case 1                     % DCT       DWT
                    dctMat_type = '2008';   %32.8976    34.x      cm:25.9,0.5_dwt    dct:24.42
                 case 2
                    dctMat_type = '2010';   %32.8900    36.30     cm:24.4,0.5_dwt  dct:24.97
                 case 3
                    dctMat_type = '2014';   %31.7715    35.x     cm:26.9,0.5_dwt   dct:25.03
                 case 4
                    dctMat_type ='2014_pot';
             end
         case 16
              switch DCTMAT
                 case 1     
                    dctMat_type = '2012';   % 31.8              29.05        cm:26.5,0.5_dwt    dct:26.43
                 case 2
                    dctMat_type = '2016';       %31.76    30.11             cm:25.1,0.5_dwt     dct:24.89
                 case 3
                    dctMat_type = '2016_orth';      % x     27.63           cm:26.5,0.5_dwt     dct:26.12
             end
     end
 end
     
 data_length =n_Q_step-Q_step_st+1;
psnr_ = zeros(n_exp,data_length);
switch N
    case 16
        r_base = 4;
    case 8
        r_base = 6;
end
if(~pDCT)
    r_base = 3;
end
  for sr_idx = [3]%[2 4 5 7 8]
      a = [N*1:N:N*N];
      for i=1%1:N;
      interv = round(N*SR(sr_idx));
     % for ii = interv:-1:4%14%:floor(SR(1)*n)-2
      for ii = 4%a(i)-interv:-1:a(i)-N+1+4
        id_bottom_r=ii-2;
        id_right_c=ii-1;
        ii
       
%     switch sr_idx
%         case 1
%             id_bottom_r=3;
%             id_right_c=4;
%         case 3
%             id_bottom_r=3;
%             id_right_c=4;
%         case 6
%             id_bottom_r=3;
%             id_right_c=4;
%     end
%image =2;
img_st = 2;
img_ed = 2;
    for image= [img_st:1:img_ed]
        ftype = '.tif';
        vidHeight = 512;   %# The image height
        vidWidth = 512;    %# The image width\
        dir = './image/';
        switch image
            case 1
                vname = 'cameraman';
                vidHeight = 256;   %# The image height
                vidWidth = 256;    %# The image width\
            case 2
                vname = 'Lena';       
            case 4 
                vname = 'mandril';
            case 3
                vname = 'barbara';
                ftype = '.png';                        
            case 5
                vname = 'peppers';
            case 6
                vname ='house';
                ftype = '.png';          
            case 7 
                vname ='F16';
                ftype = '.png';          
            case 8 
                vname ='goldhill';
                ftype = '.png';          
            case 9
                vname= 'pentagon';
                ftype = '.png';
            case 10
                vname = 'boat';
                ftype = '.png';
            case 11
                vname = 'bike';
                ftype = '.bmp';
             case 12
                vname = 'bridge';
                ftype = '.png';
            case 13
                vname= 'Sailboat';
                ftype = '.bmp';
            case 14
                vname = 'milkdrop';
                ftype = '.bmp';
            case 15
                vname = 'elaine';
                ftype = '.bmp';
            case 16
                vname = 'ruler';
                ftype = '.bmp';
              
        end
        vname
        sr=SR(sr_idx)
        fullname = strcat(dir,vname,ftype);
        A = imread(fullname); 

        for per_oneInRow =one_per%-0.54:0.1:0.8%0.0074   %0.0074;  %0.04305 %0.03:0.05:0.03;
            if(isRand)
                filename = sprintf('30PerBin01_%d_%.7f%s.mat',N,per_oneInRow,type);
            else
                filename = sprintf('stru_%d_%s.mat',N,type);
            end
            mid_val=128;
            [org_M modi_M]=generateMatrix(N,per_oneInRow,filename,id_bottom_r,id_right_c,mat_type,pDCT,dctMat_type,isRand);
            co(1) = coherence(org_M,n)
        %    co(2) = coherence(modi_M,n)
            per_oneInRow
            for f=1:1:nFrames
                f   
                Q =1;
             %   A = mov(:,:,1,f);

          for Q_step = Q_step_st:inc:n_Q_step;
                    Q_step

                    for selM = sel_st:1:n_selM  
                        selM

                         %   progress = Q_step*selM*f/(n_Q_step*nFrames*n_selM);
                         %   progress    
                            if(selM==1)
                                sensM = modi_M;
                            else
                                sensM = org_M;
                            end
                         


                            imageName = sprintf('./image/reconImage/%s/%d/SR%.2fN%dQ%d_sel%d%s%s_pdct%d_lowF%d_%s.tif',...
                                vname,N,SR(sr_idx),N,Q_step,selM,rm,ctwt,pDCT,takeLowF,dctMat_type);
                      
                            tic
                            [MSE(:,:,:,:,f),bit_per_F,PSNR(selM,f,Q),coff_ary(:,:,selM,f),SSIM(selM,f,Q)] = pred_pDCT_1F(A,SR(sr_idx),N,sensM,psi,mode,selM,Q_step,pred_method,recon_method,imageName,dctdwt,takeLowF,DCTMAT,isPrint);
                            toc
                            elapsedTime(selM,Q) = toc;
                            val_MSE(:,:,selM,f,Q) = MSE(1,1,:,:,f);
                            bits(f,Q,selM) = bit_per_F;
                            
                            mean_corcof(selM)=(mean(mean(coff_ary(:,:,selM))));
                            var_corcof(selM)=(var(var(coff_ary(:,:,selM))));
                  
                    end


                    Q =Q+1;

          end


                h_B = floor(vidHeight/N);
                w_B = floor(vidWidth/N);


                size = (h_B*w_B)*nFrames;

                avg_MSE =  sum(sum(sum(sum(val_MSE,1),2),3),4)/size;
              

            end
            PSNR
            if(pDCT)
                data_dir = './paper_data/PDCT/';
            else
                data_dir= './paper_data/';
            end
            spec_place = sprintf('%d/%s_%d-%dF_SR%.2fN%dQ%d%d_sel%d%dOnes%.7f%s%s_tLF%d_%s.mat',...
            N,vname,startF,startF+nFrames-1,SR(sr_idx),N,Q_step_st,n_Q_step,sel_st,n_selM,per_oneInRow,rm,...
            ctwt,takeLowF,dctMat_type);
        file = strcat(data_dir,spec_place);
               save(file,'val_MSE','avg_MSE','bits','PSNR','elapsedTime','co','sr','SSIM');


        cnt = cnt+1
        end  
      

    end
      end
      end
  end
 end
    %%

