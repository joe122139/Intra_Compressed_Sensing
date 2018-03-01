%function v = cal_bd_rate_pdct(N)
    %%
    path(path,'../function/')
    path(path,'../../paper_data/8/')
    path(path,'../../paper_data/16/')
     path(path,'../../paper_data/pdct/16/')
    path(path,'../../paper_data/32/')
    

      %%
      avg_diff_prop_vs_NP =[];
      avg_diff_SDPC_vs_NP=[];
    SR = [0.75 0.5 0.25];
    for idx =1:3
    %idx =2;
    sr  = SR(idx);
    num_image = 4;
    for i_name=1:num_image
        switch i_name
            case 1 
                str_n='Lena';
            case 2
                str_n ='barbara';
            case 3 
                str_n='mandril';
            case 4 
                str_n='peppers';
        end
        s_method = 'dct';
        mat_name='2016_orth';
        range =[1:7];
        for LF=1:3
         if(LF<2)
            name = sprintf('%s_1-1F_SR%0.2fN%dQ09_sel33Ones0.0000000l1PD%s_tLF%d_%s.mat',str_n,sr,16,s_method,LF,mat_name);
        else
            name = sprintf('%s_1-1F_SR%0.2fN16Q06_sel24Ones0.0430500l1PD%s.mat',str_n,sr,s_method);
        end
       %  name = sprintf('Lena_1-1F_SR0.50N16Q09_sel33Ones0.0000000l1PDdct_tLF0_2016_orth.mat');
        load (name);
            if(LF<2)
                PSNR_(LF,:) = PSNR(3,1,:);
               bits_p = bits(:,:,3).*sr;
                Bits_(LF,:) = bits_p;

            else
                  PSNR_(LF,range) = PSNR(LF,1,:);
                    bits_p = bits(:,:,LF).*sr;
                    Bits_(LF,range) = bits_p;
            end
        end

    mode= 'dsnr';

    avg_diff_prop_vs_NP(idx,i_name) = bjontegaard2(Bits_(3,range),PSNR_(3,range),Bits_(1,range),PSNR_(1,range),mode);
    avg_diff_SDPC_vs_NP(idx,i_name) = bjontegaard2(Bits_(3,range),PSNR_(3,range),Bits_(2,range),PSNR_(2,range),mode);
    %bits_p(:,:,4),PSNR(4,:).*rate,'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:)
    end
    end
    Prop =avg_diff_prop_vs_NP'
    SDPC = avg_diff_SDPC_vs_NP'
%end