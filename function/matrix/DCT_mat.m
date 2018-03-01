function [ Co ] = DCT_mat(D,inMat)
%DCT_MAT この関数の概要をここに記述
%   詳細説明をここに記述

  
 t = transpose(D);
 [N N] = size(D);
 n = N*N;
 if nargin <2
    A = sym('a', [1 n]);
 else
     A= inMat;
end
%D = sym('d', [1 n]);c
%D=reshape(D',N,N);
input=reshape(A',N,N)';

C = D*input*D';
Co= reshape(C',n,1);
end

