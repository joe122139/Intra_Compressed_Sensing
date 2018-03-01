path(path, './function/');
path(path,'./l1magic/Data');
wname = 'sym4';
vname = 'cameraman';
dir = './image/';
fullname = strcat(dir,vname,'.yuv');

vidHeight = 256;   %# The image height
vidWidth = 256;    %# The image width\
fullname = strcat(dir,vname,'.tif');
A = imread(fullname); 

[CA,CH,CV,CD] = dwt2(A,wname,'mode','per');

subplot(411)
imagesc(CV); title('Vertical Detail Image');
colormap gray;
subplot(412)
imagesc(CA); title('Lowpass Approximation');
subplot(413)
imagesc(CH); title('H Detail Image');
subplot(414)
imagesc(CD); title('D Detail Image');