path(path,'./function/')
SR_ = [0.75 0.5 0.25];

%bits_m = [bits_prop;bits_dir;bits_org;bits_allQ];
count = 1;
BD_rate=[];
N=16;
v='';
switch N
    case 16
        v='0.0430500';
    case 32
        v='0.0074000';
end
for SR =1:3
   for image=1:4
       switch image
           case 1
               image_n = 'Lena';
           case 2
               image_n = 'barbara';
           case 3
               image_n = 'mandrill';
           case 4
               image_n = 'peppers';
       end
       name = sprintf('./paper_data/%d/%s_1-1F_SR0.75N%dQ07_sel24Ones%sl1PDdct.mat',N,image_n,N,v);
       load(name);

       bits_p = bits*SR_(SR)
       BD_rate(1,count,SR)= bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,4),PSNR(4,:),mode); %BD_rate Prop.
       BD_rate(2,count,SR)= bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,2),PSNR(2,:),mode); %BD_rate SDPC
   end
    
end

%%
path(path,'./function/')
SR = [0.75 0.5 0.25];
       bits_p = bits.*SR(3);
       mode= 'rate';
avg_diff_prop_vs_NP = bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,4),PSNR(4,:),mode);
avg_diff_SDPC_vs_NP = bjontegaard2(bits_p(:,:,3),PSNR(3,:),bits_p(:,:,2),PSNR(2,:),mode);