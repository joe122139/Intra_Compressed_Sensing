%function v = cal_bd_rate_pdct(N)
    %%
    path(path,'../function/')
    path(path,'../../paper_data/8/')
    path(path,'../../paper_data/16/')
    path(path,'../../paper_data/32/')
    
    path(path,'../../paper_data/pdct/16/')
    path(path,'../../paper_data/pdct/4/')
    path(path,'../../paper_data/pdct/8/')

    

      %%
      avg_diff_prop_vs_NP =[];
      avg_diff_SDPC_vs_NP=[];
   name  ={'Lena';'barbara';'mandril';
       'peppers';
       'house';
       'F16';'goldhill';'pentagon';'boat';'bike'; 'Sailboat'; 'milkdrop';'elaine';
       %'bridge';
       'ruler'; };
    matType  ={'2013_A';'2014_pot';'2016'};
    N= 4;
     switch N
        case 4
            matIdx  =1;
            rt =0.74;
        case 8
            matIdx = 2;
            rt = 0.23;
        case 16
            matIdx = 3;
            rt =0.04305;
    end
    str_n  =char(name);
    str_matType  =char(matType);
    SR = [0.75 0.5 0.25];
    for idx =1:3
    %idx =2;
    sr  = SR(idx);
    num_image = 12;

    for i_name=4:4
        Q_st = 6;
        s_method = 'dct';    
         range =[1:7];
        for LF=1:4
             if(i_name ==4)  %peppers  
                 if (N==8)
                    if(LF>2)
                        range =[1:6];
                        Q_st = 5;
                    else
                        Q_st = 6;
                    end
                elseif(N==4)
                        Q_st = 4;
                        range =[1:5];
                 end
                
             end
             if(i_name==5 && N==4 && LF>2)
                  range = [1:5];
                Q_st = 4;
             end
         if(LF<3)
            formatSpec = string('%s_1-1F_SR%.2fN%dQ0%d_sel34Ones0.0000000l1PDdct_tLF1_%s.mat');
            name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_st,strtrim(str_matType(matIdx,:)));
         else
            formatSpec = string('%s_1-1F_SR%.2fN%dQ0%d_sel24Ones%.7fl1PDdct_tLF0_.mat');
            name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_st,rt);
        end
        load (name);
            if(LF<3)
                PSNR_(LF,:) = PSNR(2+LF,1,:);
               bits_p = bits(:,:,2+LF).*sr;
                Bits_(LF,:) = bits_p;

            else
                  PSNR_(LF,range) = PSNR(LF,1,:);
                    bits_p = bits(:,:,LF).*sr;
                    Bits_(LF,range) = bits_p;
            end
        end

    mode= 'dsnr';

    avg_diff_prop_vs_NP(idx,i_name) = bjontegaard2(Bits_(3,range),PSNR_(3,range),Bits_(1,range),PSNR_(1,range),mode);
    avg_diff_propPlus_vs_NP(idx,i_name) = bjontegaard2(Bits_(3,range),PSNR_(3,range),Bits_(2,range),PSNR_(2,range),mode);
    avg_diff_MEAP_vs_NP(idx,i_name) = bjontegaard2(Bits_(3,range),PSNR_(3,range),Bits_(4,range),PSNR_(4,range),mode);
    %bits_p(:,:,4),PSNR(4,:).*rate,'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:)
    end
    end
   
    Prop = avg_diff_prop_vs_NP'
    PropPlus =avg_diff_propPlus_vs_NP'
    MEAP = avg_diff_MEAP_vs_NP'
%end