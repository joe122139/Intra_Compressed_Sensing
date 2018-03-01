%function val_mse = ary_MSE(ary1,ary2,varargin)
function val_mse = ary_MSE(varargin)
n=numel(varargin);
if(n==1)
    error = varargin{1};
else
    error=varargin{1}-varargin{2};
end

val_mse=mean(error(:).^2);