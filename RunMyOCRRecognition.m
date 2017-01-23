function result = RunMyOCRRecognition( filename, locations, classes)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
labelMap = ['a', 'd', 'f', 'h', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 'u', 'w', 'x', 'z'];
SE = strel('disk', 3);
testIm = imread(filename);
level = graythresh(testIm);
testIm = ~im2bw(testIm, level);
% testIm = uint8(testIm<220);
testIm = imdilate(testIm, SE);
% testIm = imclose(testIm, SE);
ltestIm = bwlabel(testIm);
[testFeatures, tbb] = findBoundingBox(ltestIm, testIm, 1);
text(locations(:,2), locations(:, 1), labelMap(classes), 'Color', 'Red');
[testRow, testCol] = size(testFeatures);
[trainFeatures, trainLabels] = OCR_Extract_Features('H1-16images', 0);
% numel(trainLabels)
[normTrainFeat, means, sigmas] = Normalization(trainFeatures);
normTestFeat = (testFeatures - ones(testRow, 1) * means) ./ (ones(testRow, 1) * sigmas);
% distanceTrain = dist2(normTrainFeat, normTrainFeat);
% [sorted, in] = sort(distanceTrain, 2);
% trainIndex = in(:, 2:k+1);
% trainResultMat = trainLabels(trainIndex);
% tr = mode(trainResultMat, 2);
% trainResult = sum(tr == trainLabels) / numel(trainLabels);
distance = dist2(normTestFeat, normTrainFeat); 
[sortedDist, index] = sort(distance, 2);
rIndex = index(:, 1:7);
resultMat = trainLabels(rIndex);
r = mode(resultMat, 2);
testLabels = zeros(testRow, 1);
result = zeros(testRow, 1);
for i = 1:testRow;
    for j = 1:testRow;
        if locations(j, 1) <= tbb(i, 1) && locations(j, 1) >= tbb(i, 2) ...
                && locations(j, 2) <= tbb(i, 3) && locations(j, 2) >= tbb(i, 4);
            testLabels(i) = classes(j);
            result(j) = r(i);
            text(tbb(i, 3), tbb(i, 2), labelMap(r(i)), 'Color', 'white');
        end
    end
end
% testResult = sum(r == testLabels) / testRow;
end

