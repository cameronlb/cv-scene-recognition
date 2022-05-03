% Implementated according to the starter code prepared by James Hays, Brown University

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram.

function image_feats = get_bags_of_sifts(image_paths)
    % loading descriptors from mat file
    temp_struct = load('vocab.mat');
    train_img_descriptors = temp_struct.vocab;
    clear temp_struct;
    
    % Blurring Params:
    kernel_size = 8;
    gauss_blur_sigma = 4;
    % DSIFT Params:
    descriptor_kernel_size = 8;
    descr_kernel_step = 5;
    % Some variables
    image_paths_length = length(image_paths);
    
    %Loading bar
    calc_descriptors_loadbar = waitbar(0, 'Calculating Descriptors');
    
    % Check passed augument image_paths for array values or string values for
    % spatial pyramid function
    
    %Histogram array intilize
    image_histograms = zeros(image_paths_length, width(train_img_descriptors));
    
    for i = 1:image_paths_length

        % Check passed augument image_paths for array values or char values for
        % spatial pyramid function
        if (ischar(image_paths{i}))
            img = imread(image_paths{i});
    
        elseif (isnumeric(image_paths{i}))
            img = image_paths{i};
    
        else
            fprint("Unexpected data type found in image_paths")
        end
        grey_img = rgb2gray(img);
        grey_img = single(grey_img);
    
        % Blur greyscale image
        % sqrt(kernelSize/gaussBlur)^2-.25 <---- equvalient to sift implem
        blurred_img = vl_imsmooth(grey_img, sqrt(kernel_size/gauss_blur_sigma)^2-.25);
    
        % keypoints/frames/locations: is a 2 x NUMKEYPOINTS, col storing (x,y)
        % descriptors: 128xNUMKEYPOINTS matrix 1 descriptor per col
        % size: SIZExSIZE matrix for descriptor kernel
        % step: steps between pixel for descriptor center
        % bounds: rectangle for descriptor extraction
        % FAST: faster version of sift        
        [keypoints, img_descriptors] = vl_dsift(blurred_img, ...
                                            'step', descr_kernel_step, ...
                                            'size', descriptor_kernel_size, 'Fast');
        % cast descriptors to single type
        img_descriptors = single(img_descriptors);
        
        % histogram of vocab occurences and feature vector representation
        histogram_of_img_descriptors = zeros(1, width(train_img_descriptors));
        % pairwise comparisons
        for j = 1:width(img_descriptors)
    %         array_distances = zeros(1, width(train_img_descriptors()));
            
            % could specifiy smallest and flatten first column of matrix
            % instead of using min()
            [pairwise_matrix_values] = pdist2(transpose(img_descriptors(:, j)), transpose(train_img_descriptors));
            
            % init as single type
            min_distance_value = single(0);
            min_distance_index = single(0);
            [min_distance_value, min_distance_index] = min(pairwise_matrix_values);
                    
            histogram_of_img_descriptors(min_distance_index) = histogram_of_img_descriptors(min_distance_index) + 1;
        end
    
        % normalise image histogram and add to collection array 
        image_histograms(i, :) = histogram_of_img_descriptors/norm(histogram_of_img_descriptors);
        waitbar(i/image_paths_length, calc_descriptors_loadbar, sprintf('Bags of Sifts Progress: %d %%', floor(i/image_paths_length*100)));
        
    end
    delete(calc_descriptors_loadbar);
    
    image_feats = image_histograms;
end

% histogram('BinEdges', 0:50, 'BinCounts', histogram_of_descriptors)

% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or a visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every time at significant expense.


% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.
%}

