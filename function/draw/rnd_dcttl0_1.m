%%With rndCP, dctTL1,  dctTL0   
function v = dcttl0_1_N(n_sel)
 %   path(path,'../function/')
    path(path,'../../paper_data/pDCT/16/')
    path(path,'../../paper_data/pDCT/4/')
    path(path,'../../paper_data/pDCT/8/')  
  %  path(path,'../../paper_data/16/')

      %%
      
      col = 'rgbycw';
     markers = '.ox+*sdv^<>ph';
       %   figure_sign = string(str);
       N = [4 8 16];
       n_LF =2;
    for img_n = 1:2
    switch img_n 
        case 1
            imgN = 'Lena';
        case 2
            imgN = 'mandril';
        case 3
            imgN = 'barbara';
    end
   for  i_n = 1:1:3
      idx =2:2
    SR = [0.75 0.5 0.25 0.1];
    %idx =2;
    sr  = SR(idx);
    fondsize = 11;
    ax1 = subplot(1,2,img_n);
    set(ax1, 'FontName','Times','FontSize',fondsize); 
    range  =[4:8];
    
  %    ymin =17;
 %     ymax =37;
  %  ylim([ymin,ymax]);
    PSNR_ =[];
    Bits_ =[];
    mat_name  = '';
   
    switch i_n
        case 1 
            mat_name = '2013_A';
        case 2 
            mat_name = '2014';
        case 3 
            mat_name='2016_orth';
    end
    for LF = 1:n_LF
         s_method ='dct';   
        
         %s_method ='dwt';
        if(LF<3)
            name = sprintf('%s_1-1F_SR%0.2fN%dQ09_sel33Ones0.0000000l1PD%s_tLF%d_%s.mat',imgN,sr,N(i_n),s_method,LF-1,mat_name);
        else
            name = sprintf('Lena_1-1F_SR%0.2fN16Q06_sel24Ones0.0430500l1PD%s.mat',sr,s_method);
        end
       %  name = sprintf('Lena_1-1F_SR0.50N16Q09_sel33Ones0.0000000l1PDdct_tLF0_2016_orth.mat');
        load (name);
        if(LF<3)
            PSNR_(LF,:) = PSNR(3,1,:);
           bits_p = bits(:,:,3).*sr;
            Bits_(LF,:) = bits_p;
            
        else
            method = 3;
              PSNR_(LF,range) = PSNR(method,1,:);
                bits_p = bits(:,:,method).*sr;
                Bits_(LF,range) = bits_p;
        end
    end

    if(n_LF<3)
         h = plot(Bits_(1,range),PSNR_(1,range),Bits_(2,range),PSNR_(2,range));
    else   
        h = plot(Bits_(1,:),PSNR_(1,:),Bits_(2,:),PSNR_(2,:),Bits_(3,range),PSNR_(3,range));
    end
   % h = plot(Bits_(LF,:),PSNR_(LF,:));
    i_n
    nameArray = {'LineStyle','LineWidth'};
    valueArray = {':','-'};
    LF
    set(h(1),nameArray(1),valueArray(1));
     set(h(1),'LineWidth',1.5);
    set(h(2),nameArray(1),valueArray(2));
     set(h(2),'LineWidth',1.5);
    for i=1:length(h)
  %    set(h(i), 'Marker', markers(i*idx),'Color',col(i*idx)) % see PS below
  
            set(h(i), 'Marker', markers(length(h)*i_n)) % see PS below
    end
    hold on
   
    
 %   titlen = sprintf('SR=%.2f', sr);
  %  if(img_n>1)
   xlabel('bits(bpp)');
 %   end
     if(img_n<2)
   ylabel('PSNR(dB)');
     end
  
   end
   leg= legend('N=4    N-scan','          Z-scan','N=8    N-scan','          Z-scan','N=16  N-scan','          Z-scan');
      
    end
   
%   set(leg,'position', get(leg,'position'));
   hold off
   
end