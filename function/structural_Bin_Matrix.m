function A = structural_Bin_Matrix(n,r,q)
    H=parity_check_Matrix(r,q,'PAC');

    A = H(1:n,1:n);
  %  u_h=coherence(H,q*q)
  %  u_A =  coherence(A,n)
end