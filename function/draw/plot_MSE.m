%plot correlation coefficient
function a = plot_MSE (val_MSE,idx,wd,ht)
%%
 st  =2;
 n_sel = 3;
    for i=st:st+n_sel-1
        selM = i;
        tmp = val_MSE(:,:,i);
        %tmp = coff_ary(:,:,selM);
        %[width,height]= size(tmp);
        width = 32;
        height = 32;
        L = width*height;
        tmp1=reshape(tmp,L,1);
        figure(i);
        id = idx*(i-1);
        subplot(ht,wd*3,id)
        plot(1:L,tmp1,'.');
        ylim([0 12e5])
    end
    %%
end