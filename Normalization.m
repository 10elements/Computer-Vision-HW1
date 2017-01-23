function [ NormalFeatures, means, sigmas ] = Normalization( Features )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
means = mean(Features);
sigmas = std(Features);
[row, col] = size(Features);
meansMatrix = ones(row,1) * means;
sigmasMatrix = ones(row,1) * sigmas;
NormalFeatures = Features - meansMatrix;
NormalFeatures = NormalFeatures ./ sigmasMatrix; 
end

