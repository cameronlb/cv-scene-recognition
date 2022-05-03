function [colour_hist] = get_colour_histograms_2(image_paths)

    img = imread(image_paths{1});
    
    red = img(:,:,1);
    green = img(:,:,2);
    blue = img(:,:,3);
    

    % flatten matrix into one row and sort
    red = reshape(red.',1,[]);
    
    redCount = zeros(1,256); % number of bins / colour values
    pixelCount = 0;

    for i = 1:length(red)
        pixelCount = pixelCount + 1;

        % add 1 to index, as index + 1 = intensity value 0, index + 1 256 = 255,
        % will shift 0-255 bin values left 1. 
        index = red(i) + 1;
        
        redCount(index) =  redCount(index) + 1;
%       disp("Number of pixels indexed: " + pixelCount);

    end
    


    redIntesityValues = 0 : 255;
    bar(redIntesityValues, redCount, 'BarWidth', 1, 'FaceColor', 'b');
    xlabel('Red Value', 'FontSize', 15);
    ylabel('Pixel Count', 'FontSize', 15);
    title('Colour Intensity Histogram', 'FontSize', 15);
    grid on;

    disp("breakpoint");

    colour_hist = redCount;

end
