# Recognising-people-by-body-shape


% In this project, there are 11 parts.
% 
% Firstly, run 'crop_choose_size.m', then choose the interested area, and a crop size will be obtained.
% 
%
% Then, run 'main.m', the correct rates based on feature vectors with Fourier descriptor, area, perimeter, compactness, 
%     irrgularity and combined them all will be obtained.
% Moreover, the histogram of distances between the subjects, Correct Classification Rates for subject recognition and 
%     Equal Error Rates for subject verification will be showed after this program running.
%     
%     
% In 'main.m', there are 9 functions, and the explaination of inout and out is shown in each function.
%
% 'loadimgs.m' is the funtion to load the images from the file.
% 'crop_and_extract.m' is to get the Fourier descriptor, area of shape, perimeter and irregularity of the region.
% 'fourierdescriptor.m' and 'getsignificativedescriptors.m' is to get the Fourier descriptors.
% 'choose_FD_features.m' and 'choose_FDandregion_features.m' noamalised and set the weights to different features.
% 'crrt_rate.m' is to calculate the correct rates, ranks of the label in training dataset and the distance between 
%     the test iamge and all the training images
% 'FAR.m' and 'FRR.m' is to compute the False Reject Rate and False Accept Rate.
