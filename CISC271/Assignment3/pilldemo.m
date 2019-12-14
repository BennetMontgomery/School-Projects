% PILLDEMO loads and displays edges that were
% segmented from a Matlab standard image

% Load the image from a local directory
pillImage= imread('data/pillsetgray.png');

% Load the objects: first column is X, second is Y
load('data/object07.txt');
load('data/object08.txt');
load('data/object09.txt');
load('data/object10.txt');

% Display the image in the current figure
imshow(pillImage);
[m,n]=size(pillImage);

% Display objects, pausing between plots
disp('ENTER for segmentations, keep going...');
pause;
hold on;
plot(object07(:,1), object07(:,2), 'r.');
pause
plot(object08(:,1), object08(:,2), 'g.');
pause
plot(object09(:,1), object09(:,2), 'm.');
pause
plot(object10(:,1), object10(:,2), 'y.');
hold off

clear m n
