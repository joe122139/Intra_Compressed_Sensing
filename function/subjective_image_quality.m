
dir = '../image/reconImage/';
vname = 'lena';
%vname = 'barbara';
dir_2 = '/16/';
ftype='.tif';
size = 96;
x_st=0;
y_st=0;
switch vname
    case 'barbara'
        x_st = 80;
        y_st = 340;       
    case 'lena'
        x_st = 220;
        y_st = 200; 
end


for selM=3:3
   % vname_2 = sprintf('SR0.50N16Q4_sel%dl1PDdct',selM);
   vname_2 = sprintf('SR0.50N16Q8_sel%dl1PDdct_pdct1_lowF1_2016_orth',selM);
    fullname = strcat(dir,vname,dir_2,vname_2,ftype);
    A = imread(fullname); 
 %   A = imread('./image/Lena.tif'); 
    win = double(A(x_st:x_st+size,y_st:y_st+size));
    figure(selM);
    win=win-min(win(:)); % shift data such that the smallest element of A is 0
    win=win/max(win(:)); % normalize the shifted data to 1 
    imwrite(win(:,:),strcat(dir,vname,'/',vname_2,ftype));
    imshow(win(:,:));
end
