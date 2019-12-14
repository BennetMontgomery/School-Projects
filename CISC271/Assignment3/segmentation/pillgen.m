% PILLGEN segments a few objects from a Matlab standard image

% Load gray version of 'pilsetc.png' from a local source
pillImage= imread('pillsetgray.png');
imshow(pillImage);

% Problem size
[m,n]=size(pillImage);

% Binary (logical) segmentation of the image edges
pillEdges = edge(double(pillImage));

% Segment objects based on bounding boxes
object07 = onesndx(pillEdges, [ 70  60], [190 180]);
object08 = onesndx(pillEdges, [ 40 260], [130 370]);
object09 = onesndx(pillEdges, [130 180], [280 360]);
object10 = onesndx(pillEdges, [120 390], [230 480]);


% Interact with the user for individual plots
% Light are in red, dark are in blue
disp('ENTER for segmentations, keep going...');
pause;

imshow(pillImage);
hold on;
plot(object07(:,1), object07(:,2), 'r.');
pause
plot(object08(:,1), object08(:,2), 'g.');
pause
plot(object09(:,1), object09(:,2), 'b.');
pause
plot(object10(:,1), object10(:,2), 'y.');
hold off

% Clear the local variables from the workspace,
% leaving the image and the objects
clear m n pillEdges