function image_feats = get_spatial_pyramids(image_paths)
%GET_SPATIAL_PYRAMIDS Summary of this function goes here
%   Detailed explanation goes here
    
    % convert cell array of images to cell array of image objects (arrays)

    grey_img = single(im2gray(imread(image_paths{1}))); 
    % generate dictionary of features on each image level
    % level 1 image dict

    % level 2 4x4 image dict
    
        % divide images into 4x4 grid compute dict on each region

    % level 3 16x16 image dict

        % divide images into 16x16 grid compute dict on each region
    
    
        
        
        
    %  compute bag of sifts for each image level 


    images_feats = none;
end

