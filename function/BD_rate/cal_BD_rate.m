function v = cal_BD_rate(N)
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
    for i_name=2:num_image
        switch i_name
            case 2 
                str_n='Lena';
            case 3
                str_n ='barbara';
            case 4 
                str_n='mandril';
            case 5 
                str_n='peppers';
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
        formatSpec = string('%s_1-1F_SR%.2fN16Q06_sel24Ones0.0430500l1PDdct.mat');
        name = sprintf(formatSpec,str_n,sr);
        load (name);
 rate_mat =[0.993,0.993,0.997,0.993;...
                    0.993,0.993,0.997,0.993;...
                    0.98,0.985,0.994,0.98;];
   rate = rate_mat(idx,i_name);
        bits_p = bits.*sr;

       mode= 'rate';
   
    avg_diff_prop_vs_NP(idx,i_name) = bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,4),PSNR(4,:).*rate,mode);
    avg_diff_SDPC_vs_NP(idx,i_name) = bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,2),PSNR(2,:),mode);
    %bits_p(:,:,4),PSNR(4,:).*rate,'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:)
    end
    end
    Prop =avg_diff_prop_vs_NP'
    SDPC = avg_diff_SDPC_vs_NP'
end