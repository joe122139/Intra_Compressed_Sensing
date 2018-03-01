function [h]=appr_DCT(N)
    % Generating Haar Matrix
    N=16;
    r(1,:) = ones(1,N);
    r(2,:) = [1 1 1 1 1 0 1 1 -1 -1 0 -1 -1 -1 -1 -1];
    r(3,:) = [1 1 1 0 0 -1 -1 -1 -1 -1 -1 0 0 1 1 1];
    r(4,:) = [1 1 1 0 -1 -1 -1 -1 1 1 1 1 0 -1 -1 -1];    
    r(5,:) = [1 1 -1 -1 -1 -1 1 1 1 1 -1 -1 -1 -1 1 1];        
    r(6,:) = [1 1 -1 -1 -1 1 1 0 0 -1 -1 1 1 1 -1 -1];        
    r(7,:) = [1 0 -1 -1 1 1 0 -1 -1 0 1 1 -1 -1 0 1];   
    r(8,:) = [1 0 -1 1 1 1 -1 -1 1 1 -1 -1 -1 1 0 -1];  
    r(9,:) = [1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1];
    r(10,:) =[1 -1 -1 1 -1 -1 0 1 -1 0 1 1 -1 1 1 -1];
    r(11,:) =[1 -1 0 1 -1 0 1 -1 -1 1 0 -1 1 0 -1 1];
    r(12,:) =[0 -1 1 1 -1 1 1 -1 1 -1 -1 1 -1 -1 1 0];
    r(13,:) =[1 -1 1 -1 -1 1 -1 1 1 -1 1 -1 -1 1 -1 1];
    r(14,:) =[1 -1 1 -1 0 1 -1 1 -1 1 -1 0 1 -1 1 -1];
    r(15,:) =[0 -1 1 -1 1 -1 1 0 0 1 -1 1 -1 1 -1 0];
    r(16,:) =[1 -1 0 -1 1 -1 1 -1 1 -1 1 -1 1 0 1 -1];
    
    
    rn = rand(N,N);
    rn = orth(rn);
    a =0;
    d=det(rn)
    
    c=rn*rn'
    c = r*r'
    
    A = ones(4,4);
    A = randi([-1 1], 4, 4);
   
   co = coherence(rn,N)
    %%
    id_bottom_r = 1;
    id_right_c=2;
    a = 100000;
    while(a>10000)
        N=4;
        n = N*N;
        per_oneInRow  = 0.5;
            mp = [-1 1]; % <-- The two values you want as outputs
        P = mp((rand(1,n*n)<per_oneInRow)+1); % <-- Randomly pick one of the two values for n samples.
        Phi_ = (reshape(P, n, n)); 
        % save(filename, 'Phi_');
        org_M = Phi_;
        row1(1:n-N)=0;
        row1(n-N+1:n)=1;     %last 16 bit to be 1.
        row2=zeros(1,n);    
        row2(N:N:end)=1;  %every 16 bit to be 1.
        Phi_(id_bottom_r,:)= row1;
        Phi_(id_right_c,:)= row2;
        modi_M = Phi_;
        rn =Phi_;    




        a=0;

    end
    %%
    senM_ = r;
    save('apr16_DCT','senM_');
    ih=zeros(N,N); 
    h(1,1:N)=ones(1,N)/sqrt(N);
    for k=1:N-1 
        p=fix(log(k)/log(2)); 
        q=k-(2^p); 
        k1=2^p; t1=N/k1; 
        k2=2^(p+1); t2=N/k2; 
        for i=1:t2 
        h(k+1,i+q*t1)   = (2^(p/2))/sqrt(N); 
        h(k+1,i+q*t1+t2)    =-(2^(p/2))/sqrt(N); 
        end 
    end
end