function mod_sensM = mod_sensM(sensM,N)
    n=N*N;
    row1(1:n-N)=0;
    row1(n-N+1:n)=1;     %last N bit to be 1.
    row2=zeros(1,n);    
    row2(N:N:end)=1;  %every N bit to be 1.
    mod_sensM  = sensM;
    mod_sensM(1,:)= row1;
    mod_sensM(2,:)= row2;
    
        