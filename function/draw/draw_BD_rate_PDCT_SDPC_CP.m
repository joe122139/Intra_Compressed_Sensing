function v = draw_BD_rate(N)
    %%
    path(path,'../function/')
    path(path,'../../paper_data/8/')
    path(path,'../../paper_data/16/')
    path(path,'../../paper_data/32/')
     path(path,'../../paper_data/pdct/16/')
        set(groot,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0],...
          'defaultAxesLineStyleOrder','-|--|:|.-')

    %  load Lena_1-1F_SR0.75N16Q07_sel14Ones0.0430500l1PDdct.mat

      %%
      line=[];
      bits_p=[];
    SR = [0.75 0.5 0.25];
    idx =2;
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
            case 5
                str_n= 'house';
        end
        for lp = 1:2
          %  formatSpec = string('%s_1-1F_SR%.2fN16Q06_sel24Ones0.0430500l1PDdct.mat');
          if (lp==2)
           formatSpec = string('%s_1-1F_SR%.2fN16Q06_sel24Ones0.0430500l1PDdct.mat');
            name = sprintf(formatSpec,str_n,sr);
          else
             formatSpec = string('%s_1-1F_SR%.2fN16Q09_sel33Ones0.0000000l1PDdct_tLF1_2016_orth.mat');
             name = sprintf(formatSpec,str_n,sr);
          end
            
            load (name);
            wid = 1;
            ht = 4;
            ax1 = subplot(ht,wid,i_name);
            fondsize = 11;
            set(ax1, 'FontName','Times','FontSize',fondsize); 

            range = [2:7];
             range_dct = [2:9];
       %     bits_p = bits.*sr;
            if(lp==1)
                bits_p(:,:,1)= bits(:,:,3).*sr;
                ps(1,:) = PSNR(3,:);
            else
                bits_p(:,range,2:3)= bits(:,range,2:3).*sr;
                ps(2:3,range) = PSNR(2:3,range);
            end
      %        ymin = 20;
     %         ymax =40;
      %      ylim([ymin,ymax])
      %       xlim([1,6])
             rate_mat =[0.993,0.993,0.997,0.993;...
                        0.993,0.993,0.997,0.993;...
                        0.98,0.985,0.994,0.98;];
                   rate = rate_mat(idx,i_name);    

                   if(lp==2)
            line(:,i_name) = plot(bits_p(:,range_dct,1),ps(1,range_dct),'-m*',bits_p(:,range,2),ps(2,range),'-b<',bits_p(:,range,3),ps(3,range),':k');
                   end

            %   titlen = sprintf('%s, N=%d SR=%.2f',str_n,N,sr);
        %    titlen = sprintf('%s',lower(str_n));

           ylabel('PSNR(dB)');
           %title(titlen);
           if(i_name==4) 
               xlabel('bits(bpp)');
        end
  %  hl = legend([line(:,1),line(:,2),line(:,3),line(:,4)],['Prop.';'SDPC','NP']);
      hl = legend({'Prop.','SDPC','Dir.'});
        end

    end