function   img = block_based_DPCM_REC(N,res)
n = N*N;
x(1,:)=res(1,:);
% for i=2:n
%      x(1,i)= x(1,i-1)+res(1,i);
% end

for i=2:n
    if(mod(i,N)==1)
        x(i,:)= x(i-N,:)+res(i,:);
    else
        x(i,:)= x(i-1,:)+res(i,:);
    end
end


img = im2col(x,[N N],'distinct')';



end