function [features] = BoundingBox(im, L, fig)
%BOUNDINGBOX Summary of this function goes here
%   Detailed explanation goes here
Nc=max(max(L));
if fig==1;
    figure 
    imagesc(L)
    hold on;
end
features=[];
[h,w]=size(im);
for i=1:Nc; 
    [r,c]=find(L==i);
    maxr=max(r);
    minr=min(r);
    maxc=max(c);
    minc=min(c);
    minh=8;
    minw=8;
    if  maxc<w && maxr<h && minc>1 && minr>1 ...
        && maxr-minr>=minw && maxc-minc>=minh;
        cim = im(minr-1:maxr+1,minc-1:maxc+1);
        [centroid, theta, roundness, inmo] = moments(cim, 0);
        features=[features; theta, roundness, inmo];
        if fig==1;
            rectangle('Position',[minc,minr,maxc-minc+1,maxr-minr+1],...
                'EdgeColor','w');
        end
    end
end
if fig==1; 
    hold off; 
end
end

