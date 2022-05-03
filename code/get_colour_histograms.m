% eden's implementation - TODO: Add documentation

function histograms = get_colour_histograms(image_paths, colour, num_bins)
    histograms = [];
%     get_hist(imread(image_paths{1}), colour, num_bins);
    parfor i = 1:size(image_paths, 1)
        img = imread(image_paths{i});
        histograms = horzcat(histograms, get_hist(img, colour, num_bins));
    end
    histograms = transpose(histograms);
end

function h = get_hist(img, colour, num_bins)
    switch(lower(colour))
        case 'grayscale'
            img = rgb2gray(img);
            h = quantize(img(:), num_bins);
%             bar(h)
        case 'rgb'
            h = [];
            % iterating through each colour channel separately
            % could be slower, but it means we can re-use the quantize()
            % function- its parallelized anyway
            parfor colour_channel = 1:size(img, 3)
                colour_img = img(:, :, colour_channel);
                h = horzcat(h, quantize(colour_img(:), num_bins));
            end
%             bar(h)
            h = h(:);   % vectorize matrix, so its r values appended by g values etc
        otherwise
            throw(MException("get_colour_histograms:badarg", "Value for arg 'colour' must be equal to 'grayscale' or 'rgb'"))
    end
end

function q = quantize(img, num_bins)
    img = double(img);
    imquant = img/255;
    imquant = round(imquant*(num_bins - 1)) + 1;

    q = zeros([num_bins, 1]);
    % you could vectorize the image and just use one for loop, not
    % sure if the reduced readability is worth it though
    for i = 1:size(imquant, 1)
        for j = 1:size(imquant, 2)
            px = imquant(i, j);
            q(px) = q(px) + 1;
        end
    end
end