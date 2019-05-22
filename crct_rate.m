function [crct_rate, IDX, all_distance] = crct_rate(train, test, train_num, test_num, label)
%crct_rate is the correct rates
%IDX is the ranks of the label in training dataset
%all_distance is the distance between the test iamge and all the training images
%train is the feature vectors of training data
%test is the feature vectors of test data
%train_num is thenumber of training dataset
%test_num is thenumber of test dataset
%label is the true label of test data

%%knn classifier
[IDX, all_distance]= knnsearch(train, test, 'K', train_num);

for i = 1: test_num
    for j = 1: train_num
        %get the rank in KNN which is true label
        if IDX(i, j) == label(i)
            crrtclsf(i) = j;
        end
    end
end

%top N correct number
crrtclsf_accum = zeros(train_num, 1);
for i = 1: train_num
    for j = 1: test_num
        if crrtclsf(j) == i
            crrtclsf_accum(i) = crrtclsf_accum(i) + 1;
        end
    end
    if i > 1
        crrtclsf_accum(i) = crrtclsf_accum(i) + crrtclsf_accum(i - 1);
    end
end

%top N correct rates
crct_rate = 100 .* crrtclsf_accum ./ test_num;
end
