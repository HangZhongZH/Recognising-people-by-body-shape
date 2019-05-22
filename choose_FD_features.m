function feature_choose = choose_FD_features(fea, idx, scale)


ff_fea = [];
for i = 1: length(idx)
    ff_fea = [ff_fea abs(fea(:, idx(i)))];
end

feature_choose = ff_fea ./ (10^(scale-1));

end
