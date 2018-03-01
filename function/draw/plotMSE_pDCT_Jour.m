

    %%
    path(path,'../function/')
    path(path,'../../paper_data/4/')
    path(path,'../../paper_data/8/')
    path(path,'../../paper_data/16/')
    path(path,'../../paper_data/32/')
    path(path,'../../paper_data/pDCT/4/')
    path(path,'../../paper_data/pDCT/8/')
     path(path,'../../paper_data/pDCT/16/')
     
        set(groot,'defaultAxesColorOrder',[1 0 0;0 1 0;0 0 1;1 1 0],...
          'defaultAxesLineStyleOrder','-|--|:|.-')

    %  load Lena_1-1F_SR0.75N16Q07_sel14Ones0.0430500l1PDdct.mat

      %%
      N=8;
       switch N
        case 4
            matIdx  =1;
            rt =0.74;
        case 8
            matIdx = 2;
            rt = 0.23;
        case 16
            matIdx = 3;
            rt =0.04305;
    end
      imagesize=512;
      line=[];
    SR = [0.75 0.5 0.25];
    idx =2;
    sr  = SR(idx);
    num_image = 2;
    name  ={'Lena';'barbara';'mandril';'peppers';'house'};
    matType  ={'2013_A';'2014_pot'};
    str_n  =char(name);
    str_matType  =char(matType);
    for i_name=1:num_image
        Q_st = 6;
        if(N==4)
            if( i_name==4 || i_name==5)
                Q_st = 4;
            end
        elseif(N==8)
              if( i_name==4)
                Q_st = 5;
            end
        end
         formatSpec = string('%s_1-1F_SR%.2fN%dQ0%d_sel24Ones%.7fl1PDdct_tLF0_.mat');
     %    formatSpec = string('%s_1-1F_SR%.2fN32Q07_sel24Ones0.0074000l1PDdct.mat');
        name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_st,rt);
        
        name
        load (name);
        wid = 1;
        ht = num_image;
        fondsize = 11;
      
      st  =2;
    n_sel = 3;
    for selM=st:st+n_sel-1
    if(selM==3)
         formatSpec = string('%s_1-1F_SR%.2fN%dQ0%d_sel24Ones0.0000000l1PDdct_tLF1_%s.mat');
        name = sprintf(formatSpec,strtrim(str_n(i_name,:)),sr,N,Q_st,strtrim(str_matType(matIdx,:)));
        name
        load(name)
    end
        
        deco=[3,3,4];
        i = deco(selM-1);
        tmp = val_MSE(:,:,i,4);
 %       val_MSE(100,1:10,i,1)
        %tmp = coff_ary(:,:,selM);
        %[width,height]= size(tmp);
        width =  imagesize/N;
        height = imagesize/N;
        L = width*height;
        tmp1=reshape(tmp,L,1);
        id = (i_name-1)*n_sel+(selM-1);

       
        ax1 =subplot(ht,wid*n_sel,id);
        set(ax1, 'FontName','Times','FontSize',fondsize); 
       
        marksize = 4.5;
        plot(1:L,tmp1,'.','MarkerSize',marksize)
         xlim([0 L]);
         limY   = 2.4e4;
         ylim([0 limY])
      %  ylim auto

      %   y_tick = {'0','5','10','15'};


         set(gca,'XTick',[0:L/2:L]);
         set(gca,'YTick',[0:limY/3:limY]);
    %      tick2text('axis', 'y', 'yformat', '%g', 'ytickoffset', .05);

         

     %    set(gca,'YTickLabel',sprintf('%.2f',limY))
         
         if(mod(id,3)==1)
          ylabel('MSE');
         end
       %title(titlen);
       if(id<4) 
           xlabel('block number');
       end

    end


   
    end
