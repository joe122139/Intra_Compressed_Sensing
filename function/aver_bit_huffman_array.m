function n_aver_bits = aver_bit_huffman_array(ary,dict)
path(path, './function');
path(path, './huffman');
[height width] = size(ary);
%for i=1:height  
%    for j=1:width      
      % [bits,n]=enc_golomb(ary(i,j),sign);
    %   hcode = huffmanenco(ary,dict);
       hcode = huffman_code(ary);
       [c n] = size(hcode);
 %   end
%end

n_aver_bits = n/(width*height);
