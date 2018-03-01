

syms x0 x1 x2 x3 d0 d1 d2 d3;

%%
%N=2
D = [d0 d1; d2 d3];
input = [x0 x1;x2 x3];

C = D*input*D';

C_= reshape(C',4,1);
input_ = reshape(input',4,1);

%Phi*input=C_
Phi = C_/input_;
Phi

%%

  load('apr16_DCT.mat');
  D = senM_;
  t = transpose(D);
  co = coherence(t,16);
  c = coherence(D,16);
    
N=16;
n = N*N;
A = sym('a', [1 n]);
%D = sym('d', [1 n]);
%D=reshape(D',N,N);
input=reshape(A',N,N);

C = D*input*D';
C_= reshape(C',n,1);
input_ = reshape(input',n,1);
Phi = C_/input_;

r1 = C_(1,:)/input_;

%%
  load('mat_8_2010.mat');
  D = mat_8;
  t = transpose(D);
  co = coherence(t,8);
  c = coherence(D,8);
    
N=8;
n = N*N;
A = sym('a', [1 n]);
%D = sym('d', [1 n]);
%D=reshape(D',N,N);
input=reshape(A',N,N);

C = D*input*D';
C_= reshape(C',n,1);
input_ = reshape(input',n,1);
Phi = C_/input_;

r1 = C_(1,:)/input_;

%%
N=8;
 % load('mat_8_BAS08.mat');
  D = mat_8_BAS08;
  t = transpose(D);
  co = coherence(t,N);
  c = coherence(D,N);
    

n = N*N;
A = sym('a', [1 n]);
%D = sym('d', [1 n]);c
%D=reshape(D',N,N);
input=reshape(A',N,N);

C = D*input*D';
C_= reshape(C',n,1);
%input_ = reshape(input',n,1);
%Phi = C_/input_;

%r1 = C_(1,:)/input_;
%%
N=4;
path(path,'../apr_dct');
path(path,'./matrix');
load('apr4_DCT.mat');
D = apr4_DCT;
out =DCT_mat(D,N)

path(path,'../python');
load('m_mat4_2013.txt');
mat = m_mat4_2013;