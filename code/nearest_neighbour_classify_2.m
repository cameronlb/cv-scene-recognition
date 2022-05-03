function [outputArg1,outputArg2] = nearest_neighbour_classify_2(k, train_image_feats, train_labels, test_image_feats)
%NEAREST Summary of this function goes here
% Create an empty cell array that will 

    %   train_labels is an N x 1 cell array, where each entry is a string
    %   test_image_feats is an M x d matrix, where d is the dimensionality of the
    %   feature representation. You can assume M = N unless you've modified the
    %   starter code.
    %   predicted_categories is an M x 1 cell array, where each entry is a string
    %   indicating the predicted category for each test image.
    
%   Create an empty cell array that will 
%   Detailed explanation goes here

distances = {};

% Compute distances using euclidean distance pdist2()

for v = 1.0:-0.2:0.0
    disp(v)
end

% Get K nearest smaples and associated labels

% Sort distances and return indices

% Majority vote of the most common class labels
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

