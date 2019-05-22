function [idx, scale] = fourier_choose(fea, num)

%randomlyh choose an image
pic = 81;

[~, idx1] = sort(abs(fea(pic, :)));

idx = idx1(end - num - 1: end - 2);

t = log10(abs(fea(pic, idx(1))));
scale = floor(t);
end

