function n_aver_bits = aver_bit_expGolomb_array(ary,sign)
path(path, './function');
[height width] = size(ary);
n_sum = 0;
for i=1:height  
    for j=1:width      
       [bits,n]=enc_golomb(ary(i,j),sign);
       n_sum = n_sum + n;
    end
end

n_aver_bits = n_sum/(width*height);

