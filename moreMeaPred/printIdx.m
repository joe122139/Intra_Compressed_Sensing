N = 16;
si=sum(sensM(1:192,:),2);
fp = fopen('./meas_pred/fp.txt','w');
%{

for round = 1:16
    fprintf(fp,'round:%d\n',round);
    for s=4:20
        fprintf(fp,'\ts:%d\n',s);
        idx_all=find(si==s);
        tmp=idx_all(find(idx_all<N*round));
        len = length(tmp);
        if(len==0)
                fprintf(fp,'\t\ti:--\n');
        else
            for x = 1:length(tmp)
                fprintf(fp,'\t\ti:%d\n',tmp(x));
            end
        end
    end
end
%}

%{
for pe_id = 2:11;
   tmp=si(pe_id+1:12:192);
    for round =1:16
        fprintf(fp,'%d:\t',round);
        fprintf(fp,'y_p[0][%d] = pred[0].s_%d ',pe_id, tmp(round));
         fprintf(fp,'\n');
    end
     fprintf(fp,'\n');
end
%}


for i =0:2
    for round =1:16
        fprintf(fp,'%d:\tbegin\t',round);
        for pe_id = 0:11
            tmp=si((pe_id+1)*round);
            fprintf(fp,'y_p[%d][%d] = pred[%d].s_%d;\t',i,pe_id, i,tmp);
        end
        fprintf(fp,'end\n');
    end
    fprintf(fp,'\n');
end
fclose(fp);
