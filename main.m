clear all
clc

%load imgs
training_files = loadimgs('./training');
test_files = loadimgs('./test');

[train_num, ~] = size(training_files);
[test_num, ~] = size(test_files);

%crop size is gotten after running the program 'crop_choose_size'
crop_areaol = [861.050000000000,318.580000000000,688.000000000000,448.480000000000];
crop_area = [859.050000000000,316.580000000000,686.000000000000,448.480000000000];

%choose the first 500 descriptors
descriptors_num = 40;

%get the features of training dataset
train_fourier = zeros(train_num, descriptors_num);
train_fground = zeros(train_num, 1);
train_C = zeros(train_num, 1);
train_P = zeros(train_num, 1);
train_I = zeros(train_num, 1);
train_height = zeros(train_num, 1);
for i = 1: train_num
    [train_fourier(i, :), train_fground(i, :), train_C(i, :), train_P(i, :), train_I(i, :), train_height(i, :)] = crop_and_extact(training_files(i), crop_area, descriptors_num);
end

for i = 1: train_num
    [train_fourierol(i, :), train_fgroundol(i, :), train_Col(i, :), train_Pol(i, :), train_Iol(i, :), train_heightol(i, :)] = crop_and_extact(training_files(i), crop_areaol, descriptors_num);
end

%get the features of test dataset
test_fourier = zeros(test_num, descriptors_num);
test_fground = zeros(test_num, 1);
test_C = zeros(test_num, 1);
test_P = zeros(test_num, 1);
test_I = zeros(test_num, 1);
test_height = zeros(test_num, 1);
for i = 1: test_num
    [test_fourier(i, :), test_fground(i, :), test_C(i, :), test_P(i, :), test_I(i, :), test_height(i, :)] = crop_and_extact(test_files(i), crop_area, descriptors_num);
end

for i = 1: test_num
    [test_fourierol(i, :), test_fgroundol(i, :), test_Col(i, :), test_Pol(i, :), test_Iol(i, :), test_heightol(i, :)] = crop_and_extact(test_files(i), crop_areaol, descriptors_num);
end

%% Fourier descriptor
num = 5;
[idxol, scaleol] = fourier_choose(train_fourierol, num);
f_trainol = choose_FD_features(train_fourierol, idxol, scaleol);
f_testol = choose_FD_features(test_fourierol, idxol, scaleol);
[idx, scale] = fourier_choose(train_fourier, num);
f_train = choose_FD_features(train_fourier, idx, scale);
f_test = choose_FD_features(test_fourier, idx, scale);
%true label of test dataset
label =[48, 47, 50, 49, 52, 51, 54, 53, 56, 55, 58, 57, 60, 59, 62, 61, 64, 63, 66, 79, 87, 88];

%KNN classify
[crct_rate_FD, ~, ~] = crct_rate(f_trainol, f_testol, train_num, test_num, label);


%% combined features
f_train_plus = choose_FDandregion_features(f_train, train_fground, train_height, train_C, train_P, train_I);
f_test_plus = choose_FDandregion_features(f_test, test_fground, test_height, test_C, test_P, test_I);

%correct rates
[crct_rate_FDplus, ~, ~] = crct_rate(f_train_plus, f_test_plus, train_num, test_num, label);


%% correct rates with perimeter as the feature
[crct_rate_P, ~, ~] = crct_rate(train_P, test_P, train_num, test_num, label);


%% correct rates with area as the feature
[crct_rate_A, ~, ~] = crct_rate(train_fground, test_fground, train_num, test_num, label);


%% correct rates with compactness as the feature
[crct_rate_C, ~, ~] = crct_rate(train_C, test_C, train_num, test_num, label);


%% correct rates with irregularity as the feature
[crct_rate_I, ~, ~] = crct_rate(train_I, test_I, train_num, test_num, label);

%% distance between test image and all the training data
[~, ~, dist] = crct_rate(f_train_plus, f_test_plus, train_num, test_num, label);

%Histogram of distances between the subjects
pic1 = figure('Name', 'Histogram of distances between the subjects')
bar(dist(14, :), 'r')
xlabel('Results of Classify')
ylabel('Distance')
hold on
bar(dist(14, 1), 'b')
legend('Between class', 'Within class')
hold off

%% Correct Classification Rates for subject recognition
pic2 = figure('Name', 'Correct Classification Rates for subject recognition')
plot(crct_rate_FD(1: 5), 'b', 'linewidth',2)
xlabel('Top-N results')
ylabel('Rate')
hold on 
grid on
plot(crct_rate_FDplus(1: 7), 'r', 'linewidth',2)
hold on
plot(crct_rate_P(1: 7), 'k', 'linewidth',2)
hold on
plot(crct_rate_A(1: 7), 'm', 'linewidth',2)
hold on
plot(crct_rate_C(1: 7), 'g', 'linewidth',2)
hold on
plot(crct_rate_I(1: 7), 'c', 'linewidth',2)
hold on
legend('Fourier descriptor features', 'Fourier descriptor features and region features', ...
    'Perimeter', 'Area', 'Compactness', 'Irregularity')
hold off

%%  plot Equal Error Rates for subject verification
[~, idxx, distan] = crct_rate(f_train_plus, f_test_plus, train_num, test_num, label);

%FRR£¨False Reject Rate£©
threshold = 5;
FRR1 = FRR(distan, threshold, idxx, label);

%FAR£¨False Accept Rate£©
FAR1 = FAR(distan, threshold, idxx, label);

pic3 = figure('Name', 'Equal Error Rates for subject verification')
plot(0: threshold , FRR1, 'b', 'linewidth',3)
xlabel('Threshold')
ylabel('FRR/FAR')

hold on
grid on
plot(0: threshold, FAR1, 'r', 'linewidth',3)
legend('FRR£¨False Reject Rate', 'FAR£¨False Accept Rate')
hold off

% saveas(pic1, 'pic1.png')
% saveas(pic2, 'pic2.png')
% saveas(pic3, 'pic3.png')