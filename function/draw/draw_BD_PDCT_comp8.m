function v = draw_BD_PDCT_comp8
    path(path,'../function/')
    path(path,'../../paper_data/pDCT/8/')
    path(path,'../../paper_data/pDCT/16/')


      %%
      col = 'rgbycw';
     markers = '.ox+*sdv^<>ph';
     N=8;
       %   figure_sign = string(str);
      for idx =2:2
    SR = [0.75 0.5 0.25 0.1];
    %idx =2;
    sr  = SR(idx);
    fondsize = 11;
    ax1 = subplot(3,1,1);
    set(ax1, 'FontName','Times','FontSize',fondsize); 

 %     ymin = 20;
  %    ymax =45;
 %   ylim([ymin,ymax]);
    PSNR_ =[];
    Bits_ =[];
    for opt = 1:2
        s_method ='dct';
       % for opt =1:2
        if(opt==1)
            na = '2014'
        else
            na= '2014_pot'
        end
        %s_method ='dwt';
        name = sprintf('Lena_1-1F_SR%0.2fN8Q09_sel33Ones0.0000000l1PD%s_tLF1_%s.mat',sr,s_method,na);
        load (name);

        bits_p = bits(:,:,3).*sr;

        PSNR_(opt,:) = PSNR(3,1,:);
        Bits_(opt,:) = bits_p;
        
    end

    h = plot(Bits_(1,:),PSNR_(1,:),Bits_(2,:),PSNR_(2,:));
   % h = plot(Bits_(LF,:),PSNR_(LF,:));
    
    for i=1:length(h)
  %    set(h(i), 'Marker', markers(i*idx),'Color',col(i*idx)) % see PS below
            set(h(i), 'Marker', markers(i*idx)) % see PS below
    end
    hold on
   
    
    titlen = sprintf('N=8 SR=%.2f',sr);

    %legend('lf_0.','lf_1'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen);
     end
end