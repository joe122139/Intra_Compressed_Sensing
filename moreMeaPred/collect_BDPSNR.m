%%collect BD-psnr

for N = [4 8 16]
    i  = 1;
    [pp sd] = cal_BD_rate(N,1);
    prop(i,:,:) =pp;
    sdpc(i,:,:)=sd;
    i = i+1;
end