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
    name  ={'Lena';'barbara';'mandril';'F16';'house';'peppers'};
    matType  ={'2013_A';'2014_pot';'2016'};
    str_n  =char(name);
    str_matType  =char(matType);
    for i_name=1:num_image
        
        for lp = 1:2
      
          if (lp==2)
           Q_st = 6;
        %   formatSpec = string('%s_1-1F_SR%.2fN16Q06_sel24Ones0.0430500l1PDdct.mat');
      %      name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr);
          formatSpec = string('%s_1-1F_SR%.2fN%dQ0%d_sel24Ones%.7fl1PDdct_tLF0_.mat');
            name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_st,rt);
          else
              Q_ed = 6;
              formatSpec = string('%s_1-1F_SR%.2fN%dQ0%d_sel24Ones0.0000000l1PDdct_tLF1_%s.mat');
        %     formatSpec = string('%s_1-1F_SR%.2fN16Q09_sel33Ones0.0000000l1PDdct_tLF1_2016_orth.mat');
        %     name = sprintf(formatSpec,str_n,sr);
             name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_ed,strtrim(str_matType(matIdx,:)));
          end
            
            load (name);
            wid = 1;
            ht = 4;
            ax1 = subplot(ht,wid,i_name);
            fondsize = 11;
            set(ax1, 'FontName','Times','FontSize',fondsize); 

            range = [1:7];
             range_dct = [2:9];
       %     bits_p = bits.*sr;
            if(lp==1)
                bits_p(:,:,1:2)= bits(:,:,3:4).*sr;
                ps(1:2,:) = PSNR(3:4,:);
            else
                bits_p(:,range,3:4)= bits(:,range,3:4).*sr;
                ps(3:4,range) = PSNR(3:4,range);
            end
      %        ymin = 20;
     %         ymax =40;
      %      ylim([ymin,ymax])
      %       xlim([1,6])
    
                   if(lp==2)
                        line(:,i_name) = plot(bits_p(:,range,1),ps(1,range),'-rs',bits_p(:,range,2),ps(2,range),'-ks',bits_p(:,range,3),ps(3,range),'-mo',bits_p(:,range,4),ps(4,range),'-b<');
                        set(line(:,i_name),'LineWidth',1.75);
                   end

            %   titlen = sprintf('%s, N=%d SR=%.2f',str_n,N,sr);
        %    titlen = sprintf('%s',lower(str_n));

           ylabel('PSNR(dB)');
           %title(titlen);
           if(i_name==4) 
               xlabel('bits(bpp)');
        end
  %  hl = legend([line(:,1),line(:,2),line(:,3),line(:,4)],['Prop.';'SDPC','NP']);
      hl = legend({'Prop.','Prop.+','Dir.','MEAP'});
        end

    end