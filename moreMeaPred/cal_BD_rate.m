function [Prop] = cal_BD_rate(N,md)
    %%
    path(path,'../function/')

    
    switch N
        case 4
            rt =0.74;
        case 8
            rt = 0.23;
        case 16
            rt =0.04305;
    end
      %%
      avg_diff_prop_vs_NP =[];
      avg_diff_SDPC_vs_NP=[];
    SR = [0.75 0.5 0.25];
    for idx =1:3
    %idx =2;
        sr  = SR(idx);
        num_image = 16;
    %    for i_name=[2:4, 9:10, 13:16]%2:num_image
     for i_name=[1:1] %2:num_image
            switch i_name
                case 1
                    vname='cameraman';
                    
                case 2 
                    vname='Lena';
                case 3
                    vname ='barbara';
                case 4 
                    vname='mandril';
                case 5 
                    vname='peppers';
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
                    vname = 'ruler';
                    ftype = '.bmp';
                case 15
                    vname = 'milkdrop';
                    ftype = '.bmp';
                 case 16
                    vname = 'elaine';
                    ftype = '.bmp';
            end
            
            Q_range = 6;
            if(N==8) 
                if(i_name ==5 || i_name==12)
                    Q_range = 5;             
                end
            elseif(N==4)
                    if(i_name ==5 || i_name==6)
                        Q_range = 4;
                    elseif(i_name == 12)
                        Q_range = 1;
                    end                      
            end
            path(path,'../paper_data/moreMeasPred/8/')
            path(path,'../paper_data/moreMeasPred/16/')
            formatSpec = char('%s_1-1F_SR%.2fN%dQ0%d_sel44Ones%.7fl1PDdct_tLF0_.mat');
            name = sprintf(formatSpec,vname,sr,N,Q_range,rt);
            load (name);
            rmpath('../paper_data/moreMeasPred/8/')
             rmpath('../paper_data/moreMeasPred/16/')
             bits_prop = bits.*sr;
             PSNR_prop = PSNR;
     rate_mat =[0.993,0.993,0.997,0.993;...
                        0.993,0.993,0.997,0.993;...
                        0.98,0.985,0.994,0.98;];
       %rate = rate_mat(idx,i_name);
       rate =1;
            bits_p = bits.*sr;
            formatSpec = char('%s_1-1F_SR%.2fN%dQ0%d_sel34Ones%.7fl1PDdct_tLF0_.mat');
            name = sprintf(formatSpec,vname,sr,N,Q_range,rt);
            path(path,'../paper_data/8/')
            path(path,'../paper_data/16/')
            load(name);
             rmpath('../paper_data/16/')
              rmpath('../paper_data/8/')
            bits_p_cmp = bits.*sr;
            PSNR_cmp = PSNR;
if (md==1)
           mode= 'rate';
else
            mode= 'dsnr';
end
if(N==4)
    if(i_name==12)
        range = 1:2;
    else
        range = 1:4;
    end
        avg_diff_prop_vs_NP(idx,i_name) = bjontegaard2(bits_p_cmp(:,range,3),PSNR(3,range),bits_p(:,range,4),PSNR(4,range).*rate,mode);
 %       avg_diff_SDPC_vs_NP(idx,i_name) = bjontegaard2(bits_p(:,range,3),PSNR(3,range),bits_p(:,range,2),PSNR(2,range),mode);
else
    if(i_name==5 && N==8)
        range = 1:6;
    else
        range = 1:7;
    end
     avg_diff_prop_vs_NP(idx,i_name) = bjontegaard2(bits_p_cmp(:,range,3),PSNR_cmp(3,range),bits_prop(:,range,4),PSNR_prop(4,range).*rate,mode);
     avg_diff_previous_vs_NP(idx,i_name) = bjontegaard2(bits_p_cmp(:,range,3),PSNR_cmp(3,range),bits_p_cmp(:,range,4),PSNR_cmp(4,range).*rate,mode);
     avg_diff_previous_vs_prop(idx,i_name) = bjontegaard2(bits_p_cmp(:,range,4),PSNR_cmp(4,range),bits_prop(:,range,4),PSNR_prop(4,range).*rate,mode);
     %   avg_diff_prop_vs_NP(idx,i_name) = bjontegaard2(bits_p_cmp(:,range,4),PSNR_cmp(4,range),bits_p(:,range,4),PSNR(4,range).*rate,mode);
%        avg_diff_SDPC_vs_NP(idx,i_name) = bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,2),PSNR(2,:),mode);
end

        end
    end
    Prop =avg_diff_prop_vs_NP'
    Prep = avg_diff_previous_vs_NP'
    Diff = avg_diff_prop_vs_NP' - avg_diff_previous_vs_NP'
    Prop_Prep = avg_diff_previous_vs_prop'
  %  SDPC = avg_diff_SDPC_vs_NP'
end