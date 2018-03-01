function res = DPCM_a_block(N,img)
%res = zeros(N,N,'int16');
x = img2col(img',[N N],'distinct');

res = x;
col1 = [N:N:N*N-1];
col1_mN = col1+1; %the first column in each row, except for the 1st row
idx_all = [1:N*N];
mod_16 = find(mod(idx_all,N)~=1 & idx_all>1);
res(col1_mN,:)=x(col1_mN,:)-x(col1_mN-N,:);
res(mod_16,:) = x(mod_16,:)-x(mod_16-1,:);

end