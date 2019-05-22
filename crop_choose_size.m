clc;
clear;
close all;

%Reference: https://www.cnblogs.com/GarfieldEr007/p/5598911.html
[filename, pathname] = uigetfile({'*.jpg'; '*.bmp'; '*.gif'; '*.png' }, 'Ñ¡ÔñÍ¼Æ¬');
%if no image
if filename == 0
    return;
end

src = imread([pathname, filename]);
[m, n, z] = size(src);
figure(1)
imshow(src)

h=imrect;

%choose the interested position
pos=getPosition(h)

imCp = imcrop( src, pos);
figure(2)
imshow(imCp)



