function feature_choose_plus = choose_FDandregion_features(FD, ratio, height, C, P, I)

%arrange different weights to different features
feature_choose_plus = [280 .* ratio, height ./ 5.5, FD, C .* 10^8 .* 6, P ./ 400, I .* 1/3 ./ 10^6 ];

end
