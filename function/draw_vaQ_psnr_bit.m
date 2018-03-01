function v = draw_vaQ_psnr_bit(n_sel)
path(path,'./function/')
path(path,'./paper_data/8/')
path(path,'./paper_data/16/')
path(path,'./paper_data/32/')
    set(groot,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0],...
      'defaultAxesLineStyleOrder','-|--|:|.-')
  
%  load Lena_1-1F_SR0.75N16Q07_sel14Ones0.0430500l1PDdct.mat
  
  %%
SR = [0.75 0.5 0.25];
idx =2;
sr  = SR(idx);
%name = sprintf('Lena_1-1F_SR%.2fN16Q07_sel24Ones0.0430500l1PDdct.mat',sr);
name = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0000000l1PDdwt_tLF1.mat',sr);
load (name);
ax1 = subplot(3,1,1);
fondsize = 11;
set(ax1, 'FontName','Times','FontSize',fondsize); 



%bits_m = [bits_prop;bits_dir;bits_org;bits_allQ];
bits_p = bits.*sr;

% for i=1:n_sel
%     plot(bits_p(i,:),PSNR(i,:));
%     hold on
% end
%plot(bits_p(1,:),PSNR(1,:),'-ro',bits_p(4,:),PSNR(4,:),'-m*',bits_p(2,:),PSNR(2,:),':k',bits_p(3,:),PSNR(3,:),'-b<');
  ymin = 20;
  ymax =40;
ylim([ymin,ymax]) 
plot(bits_p(:,:,4),PSNR(4,:),'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:),':k');
%plot(bits_prop,PSNR(1,:),'-*',bits_dir,PSNR(2,:),'-o',bits_org,PSNR(3,:),':>',bits_allQ,PSNR(4,:),':*');
titlen = sprintf('N=16 SR=%.2f',sr);
legend('Prop.','SDPC','NP'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen);



%name1 = sprintf('Lena_1-1F_SR%.2fN32Q07_sel24Ones0.0074000l1PDdct.mat',sr);
name1 = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0000000l1PDdwt.mat',sr);
load (name1);
titlen1 = sprintf('N=32 SR=%.2f',sr);
  ax2 = subplot(3,1,2);
set(ax2, 'FontName','Times','FontSize',fondsize); 
bits_p = bits.*sr;
plot(bits_p(:,:,4),PSNR(4,:),'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:),':k');
  
 % ymin = 0;
 % ymax =40;
%ylim([ymin,ymax]) 
legend('Prop.','SDPC','NP'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);

%sr=SR(2);
name2 = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0430500l1PDdct.mat',sr);
load (name1);
titlen1 = sprintf('N=32 SR=%.2f',sr);
  ax3 = subplot(3,1,3);
set(ax3, 'FontName','Times','FontSize',fondsize); 
bits_p = bits.*sr;
plot(bits_p(:,:,4),PSNR(4,:),'-m*',bits_p(:,:,2),PSNR(2,:),'-b<',bits_p(:,:,3),PSNR(3,:),':k');
  
 % ymin = 0;
 % ymax =40;
%ylim([ymin,ymax]) 
legend('Prop.','SDPC','NP'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);

%%     With various SR
figure(1);
SR = [0.75 0.5 0.25 0.1 0.05];
%name = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0000000l1PDdwt_tLF1.mat',sr);

%name = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0000000l1PDdwt.mat',sr);


for i = 1:4
    sr  = SR(i+1);
    name = sprintf('Lena_1-1F_SR%.2fN16Q510_sel34Ones0.0000000l1PDdwt_tLF1.mat',sr);
    load (name);
    bits_p = bits.*sr;
    bit(i*2-1,:)= bits_p(:,:,3); P(i*2-1,:)=PSNR(3,:);
    bit(i*2,:)= bits_p(:,:,4); P(i*2,:)=PSNR(4,:);
end

color = ['rbkgykmw'];%一共7??色，用几?写几?
shape=['d*o+xvp>'];%?的形状，很多?，参看上面表格
for i = 1:8
    plot(bit(i,:),P(i,:),[color(i),shape(i),'-']);
   % plot(bit(i,:),P(i,:),style(i));
    legend(le);
    hold on
end
hold off
titlen1 = sprintf('N=16 SR=%.2f',sr);
%legend('LF-PDCT-NP.','LF-PDCT-Prop','PDCT-NP','PDCT-Prop','NP','Prop','NP','Prop'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);
legend('0.5-LF-PDCT-NP.','0.5-LF-PDCT-Prop','0.25-LF-PDCT-NP.','0.25-LF-PDCT-Prop','0.1-LF-PDCT-NP.','0.1-LF-PDCT-Prop','0.05-LF-PDCT-NP.','0.05-LF-PDCT-Prop'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);


%%     With various Matrices
figure(1);
SR = 0.5;
%name = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0000000l1PDdwt_tLF1.mat',sr);

%name = sprintf('Lena_1-1F_SR%.2fN16Q06_sel24Ones0.0000000l1PDdwt.mat',sr);


for i = 1:6
    sr  = SR;
    if(i<4)
        N=8;
    else
        N=16;
    end
    switch i
        case 1
            matrixType = '2008';
        case 2
            matrixType = '2010';
        case 3
            matrixType = '2014';    
        case 4
            matrixType = '2012';   
        case 5
            matrixType = '2016_orth';                  
    end
    name = sprintf('Lena_1-1F_SR%.2fN%dQ510_sel34Ones0.0000000l1PDdwt_tLF1_%s.mat',sr,N,matrixType);

    if(i==6)
       name = 'Lena_1-1F_SR0.50N16Q510_sel34Ones0.0430500l1PDdwt_tLF0_.mat';
    end
  %  name = sprintf('Lena_1-1F_SR%.2fN16Q510_sel34Ones0.0000000l1PDdwt_tLF1.mat',sr);
    load (name);
    bits_p = bits.*sr;
    bit(i*2-1,:)= bits_p(:,:,3); P(i*2-1,:)=PSNR(3,:);
    bit(i*2,:)= bits_p(:,:,4); P(i*2,:)=PSNR(4,:);
end

%color = ['rbkgykmbbbb'];%一共7??色，用几?写几?
color = ['rbrbrbrbrbrb'];%一共7??色，用几?写几?
%shape=  ['d*o+xvp>v^h'];%?的形状，很多?，参看上面表格
shape=  ['hhooxxvv>>ss'];%?的形状，很多?，参看上面表格
for i = 1:12
    plot(bit(i,:),P(i,:),[color(i),shape(i),'-']);
   % plot(bit(i,:),P(i,:),style(i));
    %legend(le);
    hold on
end
hold off
titlen1 = sprintf('N=16 SR=%.2f',sr);
%legend('LF-PDCT-NP.','LF-PDCT-Prop','PDCT-NP','PDCT-Prop','NP','Prop','NP','Prop'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);
%legend('0.5-LF-PDCT-NP.','0.5-LF-PDCT-Prop','0.25-LF-PDCT-NP.','0.25-LF-PDCT-Prop','0.1-LF-PDCT-NP.','0.1-LF-PDCT-Prop','0.05-LF-PDCT-NP.','0.05-LF-PDCT-Prop'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);
legend('N=8 2008.','N=8 2008 Pred','N=8 2010.','N=8 2010 Pred','N=8 2014.','N=8 2014 Pred','N=16 2012.','N=16 2012 Pred','N=16 2016.','N=16 2016 Pred','N=16 NONE','N=16 NONE Pred'),xlabel('bits(bpp)'),ylabel('PSNR(dB)'), title(titlen1);
end