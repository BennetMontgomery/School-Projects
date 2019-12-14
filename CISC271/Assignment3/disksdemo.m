% DISKSDEMO loads and displays edges that were
% segmented from a Matlab standard image

% Load the image from a local directory
disksImage= imread('data/disksimage.png');

% Load the objects: first column is X, second is Y
load('data/object01.txt');
load('data/object02.txt');
load('data/object03.txt');
load('data/object04.txt');
load('data/object05.txt');
load('data/object06.txt');

% Display the image in the current figure
imshow(disksImage);
[m,n]=size(disksImage);

% Display objects, pausing between plots
% Light are in red, dark are in blue
disp('ENTER for segmentations, keep going...');
pause;
hold on;
%plot(object01(:,1), object01(:,2), 'r.');
%pause
plot(object02(:,1), object02(:,2), 'r.');
%pause
%plot(object03(:,1), object03(:,2), 'r.');
%pause
%plot(object04(:,1), object04(:,2), 'b.');
%pause
%plot(object05(:,1), object05(:,2), 'b.');
%pause
%plot(object06(:,1), object06(:,2), 'b.');
hold off

clear m n
