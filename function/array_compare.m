%SAD:  mode==0
%SSE: mode ==1

function val_dif = array_compare (ary1,ary2,mode)

if(mode==0)
   val_dif =  sum(imabsdiff(ary1,ary2));
elseif(mode==1)
   val_dif =  ary_MSE(ary1,ary2);
else
   val_dif = -1;
end



