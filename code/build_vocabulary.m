% Based on James Hays, Brown University

function vocab = build_vocabulary(image_paths, vocab_size)
    num_clusters = vocab_size;    
    image_paths_length = length(image_paths);

    % VL_IMSMOOTH(i, SIGMA): pre smooth images at a desired level dsift does not 
    % implement gaussians.
    % kernel: for smoothing, either gauss or triangular
    % padding: handles image boundries
    % step: subsampling step
    % Adjustable Parameters
    % Blurring Params:
    kernel_size = 8;
    gauss_blur_sigma = 4;

    % DSIFT Params:
    descriptor_kernel_size = 8;
    descr_kernel_step = 5;

    train_img_descriptors = {cell(image_paths_length)}; 

    fprintf("Loading descriptors for all images: \n\n")

    calc_vocab_loadbar = waitbar(0, 'Calculating Vocab Dictionary');

    if isfile('train_img_descriptors_file.mat')
        % matlab is shit so have to do this shit code to load cellarray
        % from struct/.mat file

        % might be worth rescaling all images to specific size
        temp_struct = load('train_img_descriptors_file.mat');
        train_img_descriptors = temp_struct.train_img_descriptors;
        fprintf("Descriptors loaded from file: \n\n")
        clear temp_struct;
    else
        fprintf("Descriptors file not found computing descriptors: \n\n")
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
            % sqrt(kernelSize/gaussBlur)^2-.25 <---- equvalient to sift implem
            blurred_img = vl_imsmooth(grey_img, sqrt(kernel_size/gauss_blur_sigma)^2-.25);
        
            % keypoints/frames/locations: is a 2 x NUMKEYPOINTS, col storing (x,y)
            % descriptors: 128xNUMKEYPOINTS matrix 1 descriptor per col
            % size: SIZExSIZE matrix for descriptor kernel
            % step: steps between pixel for descriptor center
            % bounds: rectangle for descriptor extraction
            % FAST: faster version of sift
            [keypoints, descriptors] = vl_dsift(blurred_img, ...
                                                'step', descr_kernel_step, ...
                                                'size', descriptor_kernel_size);
            
            % could be worth radomizing feature descrip and limiting each
            % images amount equal to each other or other destinance metrics
            train_img_descriptors{i} = single(descriptors); 
            waitbar(i/image_paths_length, calc_vocab_loadbar, sprintf('Building vocab dictionary progress: %d %%', floor(i/image_paths_length*100)));
        end
    end
    delete(calc_vocab_loadbar)
    for i = 1:length(train_img_descriptors)
        [centers, assignments] = vl_kmeans(train_img_descriptors{i}, num_clusters);
    end

    vocab = centers;
end


% The inputs are images, a N x 1 cell array of image paths and the size of 
% the vocabulary.

% The output 'vocab' should be vocab_size x 128. Each row is a cluster
% centroid / visual word.

%{ 
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be thrown away here
  (but possibly used for extra credit in get_bags_of_sifts if you're making
  a "spatial pyramid").
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

[centers, assignments] = vl_kmeans(X, K)
 http://www.vlfeat.org/matlab/vl_kmeans.html
  X is a d x M matrix of sampled SIFT features, where M is the number of
   features sampled. M should be pretty large! Make sure matrix is of type
   single to be safe. E.g. single(matrix).
  K is the number of clusters desired (vocab_size)
  centers is a d x K matrix of cluster centroids. This is your vocabulary.
   You can disregard 'assignments'.

  Matlab has a build in kmeans function, see 'help kmeans', but it is
  slower.
%}

% Load images from the training set. To save computation time, you don't
% necessarily need to sample from all images, although it would be better
% to do so. You can randomly sample the descriptors from each image to save
% memory and speed up the clustering. Or you can simply call vl_dsift with
% a large step size here, but a smaller step size in make_hist.m. 

% For each loaded image, get some SIFT features. You don't have to get as
% many SIFT features as you will in get_bags_of_sift.m, because you're only
% trying to get a representative sample here.

% Once you have tens of thousands of SIFT features from many training
% images, cluster them with kmeans. The resulting centroids are now your
% visual word vocabulary.