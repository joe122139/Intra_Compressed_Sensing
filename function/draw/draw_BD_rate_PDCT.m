%%With different SR
function v = draw_vaQ_psnr_bit(n_sel)
    path(path,'../function/')
    path(path,'../../paper_data/pDCT/8/')
    path(path,'../../paper_data/pDCT/16/')


      %%
      col = 'rgbycw';
     markers = '.ox+*sdv^<>ph';
       %   figure_sign = string(str);
      for idx =1:4
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
    for LF = 1:2
        s_method ='dct';
        %s_method ='dwt';
        name = sprintf('Lena_1-1F_SR%0.2fN16Q09_sel33Ones0.0000000l1PD%s_tLF%d_2016_orth.mat',sr,s_method,LF-1);
        load (name);

        bits_p = bits(:,:,3).*sr;

        PSNR_(LF,:) = PSNR(3,1,:);
        Bits_(LF,:) = bits_p;
   
    end

    h = plot(Bits_(1,:),PSNR_(1,:),Bits_(2,:),PSNR_(2,:));
   % h = plot(Bits_(LF,:),PSNR_(LF,:));
    
    for i=1:length(h)
  %    set(h(i), 'Marker', markers(i*idx),'Color',col(i*idx)) % see PS below
            set(h(i), 'Marker', markers(i*idx)) % see PS below
    end
    hold on
   
    
    titlen = sprintf('N=16 SR=%.2f',sr);

    %legend('lf_0.','lf_1'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen);
     end
end