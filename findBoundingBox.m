function [Features, BoundingBoxes]=findBoundingBox( labeled_image , image, display)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Nc=max(max(labeled_image)); 
[h, w] = size(labeled_image);
if display==1
    figure; 
    imagesc(labeled_image);
    hold on;
end
Features = zeros(Nc, 13);
BoundingBoxes = zeros(Nc, 4);
j = 1;
for i=1:Nc; 
    [r, c] = find(labeled_image==i);
    maxr = max(r);
    minr = min(r);
    maxc = max(c);
    minc = min(c);
    if maxr-minr >= 8 && maxc-minc >= 8 && maxr-minr<=100 && maxc-minc<=100 && ...
            maxr<h && minr>1 && maxc<w && minc>1 ...
             &&(((maxr-minr)/(maxc-minc)<=4 && (maxr-minr)/(maxc-minc)>=1)||((maxc-minc)/(maxr-minr)<=4)&&((maxc-minc)/(maxr-minr)>=1));
        cim = image(minr - 1:maxr + 1, minc - 1:maxc + 1);
        rowHist = sum(cim, 1);
        colHist = sum(cim, 2);
        varRH = std(rowHist);
        varCH = std(colHist);
        [l, num] = bwlabel(~cim);
        maxArea = 0;
        for n = 2:num;
            if sum(sum(l == n)) > maxArea;
                maxArea = sum(sum(l == n));
            end
        end
        maxArea = maxArea / (maxr - minr) * (maxc - minc);
        [centroid, theta, roundness, inmo] = moments(cim, 1);
        Features(j,:) = [ theta, roundness, inmo, ...
              num, maxArea, (maxr - minr) / (maxc - minc), varRH, varCH, centroid(1) / (maxc - minc), centroid(2) / (maxr - minr)];
        BoundingBoxes(j,:) = [maxr, minr, maxc, minc];
        j = j + 1;
        if display == 1;
            rectangle('Position',[minc, minr, maxc - minc + 1, maxr - minr + 1], 'EdgeColor','w');
        end
    end
end
Features(j:Nc,:) = [];
BoundingBoxes(j:Nc,:) = [];
    hold off;
end

