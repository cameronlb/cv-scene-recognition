function image_feats = get_tiny_images_2(image_paths, imsize, resize_method, colour)
    
    image_feats = [];

    parfor i = 1:size(image_paths, 1)
%         fprintf("Working on: %s\n", image_paths{i});

        img = imread(image_paths{i});

        switch(lower(resize_method))
            case 'distort'
                img = imresize(img, [imsize, imsize]);
            case 'crop'
                % resize to smallest dimension
                if size(img, 1) > size(img, 2)
                    img = imresize(img, [NaN, imsize]);
                else
                    img = imresize(img, [imsize, NaN]);
                end
                % resize first then crop, possibly faster
%                 fprintf("%d:%d\n", size(img, 1), size(img, 2));
                img = imcrop(img, centerCropWindow2d(size(img), [imsize, imsize]));
            otherwise
                throw(MException("tinyimages:badarg", "Value for arg 'resize_method' must be equal to 'distort' or 'crop'"))
        end

        switch(lower(colour))
            case 'grayscale'
                img = rgb2gray(img);
                image_feats = horzcat(image_feats, img(:));
            case 'rgb'
                image_feats = horzcat(image_feats, img(:));
            otherwise
                throw(MException("tinyimages:badarg", "Value for arg 'colour' must be equal to 'grayscale' or 'rgb'"))
        end
        
%         imshow(img);
    end
    image_feats = double(transpose(image_feats));
end