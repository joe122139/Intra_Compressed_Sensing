function [org_M modi_M morePattern_M] = genMatrix(N,per_oneInRow,filename,id_bottom_r,id_right_c,mat_type,isRand)
n=N*N;
      if(exist(filename,'file') && mat_type~=2)
         load(filename,'Phi_');
      else
          if(mat_type==1)
            mp = [0 1]; % <-- The two values you want as outputs
          elseif(mat_type==2)
            mp = [1 -1];
            per_oneInRow= 0.5;
          end
            if(mat_type<3)
                P = mp((rand(1,n*n)<per_oneInRow)+1); % <-- Randomly pick one of the two values for n samples.  
            else
                P = randi([-1,1],n,n);
            end

            if(isRand)
                Phi_ = (reshape(P, n, n)); 
          %      Phi_ = orth(Phi_);
            end   
            save(filename, 'Phi_');
      end
  
 % load('apr16_DCT.mat');
%  Phi_ = senM_;
  
org_M = Phi_;
tmp = Phi_;
row1(1:n-N)=0;
row1(n-N+1:n)=1;     %last 16 bit to be 1.
row2=zeros(1,n);    
row2(N:N:end)=1;  %every 16 bit to be 1.
Phi_(id_bottom_r,:)= row1;
Phi_(id_right_c,:)= row2;
modi_M = Phi_;


r1(1:n)=0;
r2(1:n)=0;
r3(1:n)=0;
r4(1:n)=0;
r5(1:n)=0;
r6(1:n)=0;
r7(1:n)=0;
r8(1:n)=0;

if(N==4)
    r1(15:16)=1;
    r2(13:14)=1;
    r3(4)=1;
    r3(8)=1;
    r4(12)=1;
    r4(16)=1;
elseif (N==8)
    r1(n-N/2+1:n)=1;
    r2(n-N+1:n-N/2)=1;
    r3(N:N:32)=1;
    r4(32+N:N:n)=1;
elseif (N==16 )
    r1(n-N/4+1:n)=1;
    r2(n-N/2+1:n-N/4)=1;
    r3(n-N+1+N/4:n-N/2)=1;
    r4(n-N+1:n-N+N/4)=1; 
    r5(N:N:4*N)=1;
    r6(5*N:N:8*N)=1;
    r7(9*N:N:12*N)=1;
    r8(13*N:N:n)=1;
end
Phi_ = tmp;
Phi_(1,:)= r1;
Phi_(2,:)= r2;
Phi_(3,:)= r3;
Phi_(4,:)= r4;
if(N>8)
    Phi_(5,:)= r5;
    Phi_(6,:)= r6;
    Phi_(7,:)= r7;
    Phi_(8,:)= r8;
end
morePattern_M = Phi_;
