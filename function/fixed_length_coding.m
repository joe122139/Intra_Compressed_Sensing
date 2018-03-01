function n_aver_bits = fixed_length_coding(ary,fixLength)
[height width] = size(ary);
n_sum = 0;
for i=1:height  
    for j=1:width      
       bits=dec2bin(ary(i,j),fixLength);
       n=length(bits);
       n_sum = n_sum + n;
    end
end

n_aver_bits = n_sum/(width*height);
