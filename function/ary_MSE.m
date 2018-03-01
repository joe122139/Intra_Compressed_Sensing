function val_mse = ary_MSE(ary1,ary2)

error=ary1-ary2;

val_mse=mean(error(:).^2);