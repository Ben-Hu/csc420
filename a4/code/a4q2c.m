%% Assignment 4 Q2c
%Visualize the three images with the 
%best detections of car, person, and bicycle
%car = red
%person = blue
%bicycle = cyan
% - text function - add label to each bounding box as well
clear all; close all;
globals;
addpath(genpath(pwd))

%% Get dataset to process
data = getData([], 'test', 'list'); 
% cast cell to str 
ids = string(data.ids(1:3));

%% Left camera imgs and detections
for i=1:size(ids,1)
    eval(sprintf('imdata = getData(ids(%d), ''test'', ''left'');', i));
    eval(sprintf('img%dLeft = imdata.im;', i));
    eval(sprintf('img%dLeftCarRes = getData(ids(%d), [], ''result_car_left'');',i,i));
    eval(sprintf('img%dLeftCarRes = img%dLeftCarRes.ds;',i,i));
    eval(sprintf('img%dLeftPersonRes = getData(ids(%d), [], ''result_person_left'');',i,i));
    eval(sprintf('img%dLeftPersonRes = img%dLeftPersonRes.ds;',i,i));
    eval(sprintf('img%dLeftBicycleRes = getData(ids(%d), [], ''result_bicycle_left'');',i,i));
    eval(sprintf('img%dLeftBicycleRes = img%dLeftBicycleRes.ds;',i,i));
end

%% Right camera imgs and detections
for i=1:size(ids,1)
    eval(sprintf('imdata = getData(ids(%d), ''test'', ''right'');', i));
    eval(sprintf('img%dRight = imdata.im;', i)); 
    eval(sprintf('img%dRightCarRes = getData(ids(%d), [], ''result_car_right'');',i,i));
    eval(sprintf('img%dRightCarRes = img%dRightCarRes.ds;',i,i));
    eval(sprintf('img%dRightPersonRes = getData(ids(%d), [], ''result_person_right'');',i,i));
    eval(sprintf('img%dRightPersonRes = img%dRightPersonRes.ds;',i,i));
    eval(sprintf('img%dRightBicycleRes = getData(ids(%d), [], ''result_bicycle_right'');',i,i));
    eval(sprintf('img%dRightBicycleRes = img%dRightBicycleRes.ds;',i,i));
end
% 
% figure; imagesc(img1Left);axis image;
% figure; imagesc(img2Left);axis image;
% figure; imagesc(img3Left);axis image;
% 
% figure; imagesc(img1Right);axis image;
% figure; imagesc(img2Right);axis image;
% figure; imagesc(img3Right);axis image;



%% Plot the boxes on the images
% IMG1LEFT
plotBoxes(img1Left, img1LeftCarRes, img1LeftPersonRes, img1LeftBicycleRes);

% IMG2LEFT
plotBoxes(img2Left, img2LeftCarRes, img2LeftPersonRes, img2LeftBicycleRes);

% IMG3LEFT
plotBoxes(img3Left, img3LeftCarRes, img3LeftPersonRes, img3LeftBicycleRes);


% IMG1RIGHT
plotBoxes(img1Right, img1RightCarRes, img1RightPersonRes, img1RightBicycleRes);

% IMG2RIGHT
plotBoxes(img2Right, img2RightCarRes, img2RightPersonRes, img2RightBicycleRes);

% IMG3RIGHT
plotBoxes(img3Right, img3RightCarRes, img3RightPersonRes, img3RightBicycleRes);

%% Plot all the bounding boxes for cars, persons, and bicycles on the img
function plotBoxes(img,carRes,personRes,bicycleRes)
    % Results (ds) format
    % The bounding box is represented with two corner points, 
    % the top left corner (xleft,ytop) and the bottom right corner (xright,yright).
    % score is the strength of the detection
    % ds = [xleft,ytop,xright,ybottom,ID,score;...] 
    clean = 5;
    figure;imagesc(img);axis image;hold on;
    for i=1:min(clean,size(carRes,1))
        bounds = carRes(i,1:4);
        xl = bounds(1);
        yt = bounds(2);
        xr = bounds(3);
        yb = bounds(4);
        xp = [xl,xr,xr,xl,xl];
        yp = [yb,yb,yt,yt,yb];
        plot(xp,yp,'r','LineWidth',2); 
    end
    for i=1:min(clean,size(personRes,1))
        bounds = personRes(i,1:4);
        xl = bounds(1);
        yt = bounds(2);
        xr = bounds(3);
        yb = bounds(4);
        xp = [xl,xr,xr,xl,xl];
        yp = [yb,yb,yt,yt,yb];
        plot(xp,yp,'b','LineWidth',2); 
    end
    for i=1:min(clean,size(bicycleRes,1))
        bounds = bicycleRes(i,1:4);
        xl = bounds(1);
        yt = bounds(2);
        xr = bounds(3);
        yb = bounds(4);
        xp = [xl,xr,xr,xl,xl];
        yp = [yb,yb,yt,yt,yb];
        plot(xp,yp,'c','LineWidth',2); 
    end
    hold off;
end
