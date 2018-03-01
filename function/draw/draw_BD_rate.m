function v = draw_BD_rate(N,sr_idx)
    %%
%    path(path,'../function/')
    path(path,'../../paper_data/4/')
    path(path,'../../paper_data/8/')
    path(path,'../../paper_data/16/')
    path(path,'../../paper_data/32/')
        set(groot,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0],...
          'defaultAxesLineStyleOrder','-|--|:|.-')

   % figure(1)
     switch N
        case 4
            rt =0.74;
        case 8
            rt = 0.23;
        case 16
            rt =0.04305;
    end
      line=[];
    SR = [0.75 0.5 0.25];
  %  sr_idx =3;
    sr  = SR(sr_idx);
    num_image = 4;
    name  ={'Lena';'goldhill';'mandril';'pentagon';'peppers';'house';'F16';'barbara';'boat';'bike';'bridge';'Sailboat'};
    str_n  =char(name);
    for i_name=1:num_image
         Q_st = 6;
        if(N==4)
            if( i_name==5 || i_name==6)
                Q_st = 4;
            end
        elseif(N==8)
              if( i_name==5)
                Q_st = 5;
            end
        end
         formatSpec = char('%s_1-1F_SR%.2fN%dQ0%d_sel24Ones%.7fl1PDdct_tLF0_.mat');
        name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_st,rt);
        load (name);
        wid = 1;
        ht = num_image/wid;
        ax1 = subplot(ht,wid,i_name);
        fondsize = 11;
        set(ax1, 'FontName','Times','FontSize',fondsize); 

        bits_p = bits.*sr;

          ymin = 20;
          ymax =40;
        ylim([ymin,ymax])
         xlim([1,6])
        if(N==16)
         rate_mat =[0.993,0.993,0.997,0.993,1,1,1,1,1,1,1,1;...
                    0.993,0.998,0.998,1,1,1,1,1,1,1,1,1;...
                    0.98,0.985,0.994,0.98,1,1,1,1,1,1,1,1;];
                
                 rate = rate_mat(sr_idx,i_name);    
        elseif(N==8)
               rate_mat =[0.993,0.993,0.997,0.993,1,1,1,1,1,1,1,1;...
                    0.990,0.990,0.992,0.990,1,1,1,1,1,1,1,1;...
                    0.98,0.985,0.994,0.98,1,1,1,1,1,1,1,1;];
                
                rate = rate_mat(sr_idx,i_name);    
        else
                  rate_mat =[0.993,0.993,0.997,0.993,1,1,1,1,1,1,1,1;...
                    0.990,0.990,0.995,0.990,1,1,1,1,1,1,1,1;...
                    0.98,0.985,0.994,0.98,1,1,1,1,1,1,1,1;];
                  rate = rate_mat(sr_idx,i_name);    
        end
        rate =1;
              
 if(N==4)
     range = 1:6;
 %    range = 1:6;
  %   if(i_name == 4)
  %         range = 1:5;
   %  end
     line(:,i_name) = plot(bits_p(:,range,4),PSNR(4,range).*rate,'-m*',bits_p(:,range,2),PSNR(2,range),'-b<',bits_p(:,range,3),PSNR(3,range),':k');
 else
        line(:,i_name) = plot(bits_p(:,:,4),PSNR(4,:).*rate,'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:),':k');
 end 
        %   titlen = sprintf('%s, N=%d SR=%.2f',str_n,N,sr);
    %    titlen = sprintf('%s',lower(str_n));

       ylabel('PSNR(dB)');
       %title(titlen);
   %    if(i_name==4) xlabel('bits(bpp)');
           xlabel(num2str(i_name));
    end
  %  hl = legend([line(:,1),line(:,2),line(:,3),line(:,4)],['Prop.';'SDPC','NP']);
      hl = legend({'Prop.','SDPC','NP'});
end