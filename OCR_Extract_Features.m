function [Features, labels] = OCR_Extract_Features( path, display)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
l = dir(path);
labels = zeros(1500, 1);
Features = zeros(1500, 13);
j = 1;
SE = strel('disk', 3);
labelMap = containers.Map({'a', 'd', 'f', 'h', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 'u', 'w', 'x', 'z'},...
    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16});
for i = 1:numel(l);
    height = 0;
    if l(i).isdir == 0;
        x = strsplit(l(i).name, '.');
        if isempty(x{1})==0
            %                l(i).name
            %                [path, '/', l(i).name]
            im = imread([path '/' l(i).name]);
            level = graythresh(im);
            im = ~im2bw(im, level);
            %                im = uint8(im < 220);
            im = imdilate(im, SE);
            %                im = imclose(im, SE);
            lim = bwlabel(im);
            f = findBoundingBox(lim, im, display);
            s = size(f);
            height = s(1);
            l(i).name
            height
            Features(j:j+height-1,:) = f;
            labels(j:j+height-1) = labelMap(x{1});
            j = j + height;
        end
    end
end
Features(j:1500,:) = [];
labels(j:1500,:) = [];
end

