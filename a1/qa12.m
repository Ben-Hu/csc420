function [outImg] = myConvolution(img, filt);
%Question 1 a)
%img Image 
%filt Filter assumed n x n where n is odd
%outImg Convolution of img and filt (output same size as img)
[numRowsFilt, numColsFilt] = size(filt); % Size of input filter
[numRowsImg, numColsImg] = size(img); % Size of input image

% Flip the filter in both directions
filt=flipud(fliplr(filt));

% Pad image with k zeroes, k = offset of the filter's origin to an edge 
filterOffset = (numRowsFilt - 1) / 2;
paddedImg = padarray(img,[filterOffset filterOffset]);

% Convolution, start and end with filter origin on bounds of original image
for imgRow = 1+filterOffset:numRowsImg+filterOffset 
        for imgCol = 1+filterOffset:numColsImg+filterOffset 
            % Convolution on pixel paddedImg[imgCol,imgRow] 
            areaToFilter = ...
                (paddedImg(imgCol-filterOffset:imgCol+filterOffset, ...
                imgRow-filterOffset:imgRow+filterOffset));
            % Sum element-wise mult of areaToFilter and filt
            outImg(imgCol-filterOffset,imgRow-filterOffset) = ...
                sum(sum(areaToFilter.*filt,1),2);
        end
end

end
