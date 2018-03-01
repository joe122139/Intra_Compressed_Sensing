function [org_M modi_M] = generateMatrix(N,per_oneInRow,filename,id_bottom_r,id_right_c,mat_type,pDCT,DCTMat_type,isRand)
n=N*N;
  if(~pDCT)
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
               
            else
                switch N
                    case 16
                        q=17;
                    case 32
                        q = 33;
                end
               r=q;
                A = structural_Bin_Matrix(N,r,q);  
                Phi_ = A;
            end

            save(filename, 'Phi_');


      end
  else
  %      path(path, './python/');
        path(path,'./apr_DCT/input/')
        if(N==16)
            switch DCTMat_type
                case '2016'
                    load('mat_16_Silveira_2016.mat');  
                    mat =mat_16_Silveira_2016;
                case '2016_orth'
                    load('mat_16_sil_2016_orth.txt');  
                    mat = mat_16_sil_2016_orth;
                case '2012'
                    load('mat_16_2012.txt');  
                    mat = mat_16_2012;
            end
        elseif (N==8)
            switch DCTMat_type
                case '2010'
                    load('mat_8_2010.mat');   
                    mat = mat_8_RDCT;
                case '2008'
                    load('mat_8_BAS08.mat');   
                    mat = mat_8_BAS08;
                case '2014'
                    load('mat_8_T4_2014.mat');   
                    mat = mat_8_T4_2014;
                case '2014_pot'
                    load('mat_8_Potluri_2014.txt');
                    mat =mat_8_Potluri_2014;
            end
        elseif(N==4)
            switch DCTMat_type
                case '2013_A'
                    load('apr4_DCT.mat');   
                    mat = apr4_DCT;
                case '2013_B'
                    load('apr4_DCT_B.txt');   
                    mat = apr4_DCT_B;
            end
        end
        Phi_ = dct_measurement(mat);
        
  end
 % load('apr16_DCT.mat');
%  Phi_ = senM_;
  
org_M = Phi_;
row1(1:n-N)=0;
row1(n-N+1:n)=1;     %last 16 bit to be 1.
row2=zeros(1,n);    
row2(N:N:end)=1;  %every 16 bit to be 1.
Phi_(id_bottom_r,:)= row1;
Phi_(id_right_c,:)= row2;
modi_M = Phi_;


