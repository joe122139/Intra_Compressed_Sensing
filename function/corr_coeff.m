function cc = corr_coeff(A,B) % correlation coefficients of two vectors
%
x = dot(A,B);
y = norm(A)*norm(B);
cc = x/y;
