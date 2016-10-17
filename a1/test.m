clear all;close all;
img = double(imread('cameraman.tif'));
bigImg = rgb2gray(double(imread('hires.jpg'))/255);
catImg = rgb2gray(double(imread('cat.jpg'))/255);
noiseTemplate = (double(imread('templateNoise.png'))/255);
waldoNoise = (double(imread('waldoNoise.png'))/255);


tempConv1 = imgaussfilt(noiseTemplate,2);
tempConv2 = imgaussfilt(noiseTemplate,4);
tempConv3 = imgaussfilt(noiseTemplate,8);

waldoConv1 = imgaussfilt(waldoNoise,2);
waldoConv2 = imgaussfilt(waldoNoise,4);
waldoConv3 = imgaussfilt(waldoNoise,8);

findwal0 = findWaldo(waldoNoise, noiseTemplate);
findwal1 = findWaldo(waldoConv1, tempConv1);
findwal2 = findWaldo(waldoConv2, tempConv2);
findwal3 = findWaldo(waldoConv3, tempConv3);

%figure; imagesc(waldoConv1);axis image; colormap gray;
%figure; imagesc(waldoConv2);axis image; colormap gray;
%figure; imagesc(waldoConv3);axis image; colormap gray;
%figure; imagesc(tempConv1);axis image; colormap gray;
%figure; imagesc(tempConv2);axis image; colormap gray;
%figure; imagesc(tempConv3);axis image; colormap gray;


%figure; imagesc(catImg);axis image; colormap gray;
%convCat = imgaussfilt(catImg,[15,2]);
%figure;imagesc(convCat);axis image; colormap gray;


%Create a seperable filter
hx =[1 2 1];
hy = [1 2 1]';
H = hy*hx;
hx = hx/sum(hx(:));
hy = hy/sum(hy(:));
H = H/sum(H(:));%normalize the filter

%figure;imagesc(bigImg);axis image;colormap gray;

imgSmooth = conv2(img,H,'same');
%figure;imagesc(imgSmooth);axis image;colormap gray;

myImgSmooth = myConvolution(img,H);
%figure;imagesc(myImgSmooth);axis image;colormap gray;


%% Gaussian convolution associativity
%x = imgaussfilt(imgaussfilt(bigImg,8),3);
%y = imgaussfilt(bigImg,sqrt(2)*5.5);

%figure;imagesc(x);axis image;colormap gray;




% Anisotropic gaussian convolutions 
builtinAniso = imgaussfilt(img, [15,2]);
bisize = computeFilterSizeFromSigma([15,2]);
%f = fspecial('gaussian', [11,11], 2)
%builtinAniso = conv2(img, f, 'same');
%figure;imagesc(builtinAniso);axis image;colormap gray;

%f2 = genAnisoGauss(61,9,15,2)
%myAniso = conv2(img, genAnisoGauss(61,9,15,2), 'same');
%figure;imagesc(myAniso);axis image;colormap gray;
















%imggaussfilt uses filter size
function filterSize = computeFilterSizeFromSigma(sigma)
filterSize = 2*ceil(2*sigma) + 1;
end


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

%Question 2 c)
%generate an anisotropic gaussian kernel for given sigma_x and sigma_y of
%size x,y -- current assumption is x=y - fix this
function [myAnisoGauss] = genAnisoGauss(x, y, sig_x, sig_y)

xOffset = (x-1)/2;
yOffset = (y-1)/2;

%xCoord = matrix w/ x value wrt the origin (0) e.g. [-1,0,1;-1,0,1;1,0,1]
%yCoord = matrix w/ y values wrt the origin, upsidedown [-1,-1,-1;0,0,0;1,1,1]
[xCoord,yCoord] = meshgrid(-xOffset:xOffset,-yOffset:yOffset);

%pre-allocate myAnisoGauss
myAnisoGauss = zeros(x,y);

for xIter = 1:x
    for yIter = 1:y
        a = 1/(2*pi*sig_x*sig_y);
        b = (xCoord(xIter,yIter).*xCoord(xIter,yIter))/(sig_x*sig_x) + ...
            (yCoord(xIter,yIter).*yCoord(xIter,yIter))/(sig_y*sig_y);
        res = a * exp(-b/2); 
        myAnisoGauss(xIter,yIter) = res;      
    end
end

end




