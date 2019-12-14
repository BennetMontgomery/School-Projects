% DISKSGEN segments circles from a Matlab standard image

% Load 'circlesBrightDark.png' from a local source
disksImage= imread('disksimage.png');
imshow(disksImage);

% Problem size
[m,n]=size(disksImage);

% Binary (logical) segmentation of the light & dark edges
imglight = (disksImage>129 & disksImage<131);
imgdark  = (disksImage<127 & disksImage>125);

% Extract edge indexes, based on bounding boxes
object01 = onesndx(imglight, [20   40], [170 160]);
object02 = onesndx(imglight, [210  30], [290 130]);
object03 = onesndx(imglight, [320 180], [480 330]);
object04 = onesndx(imgdark, [70 250], [170 350]);
object05 = onesndx(imgdark, [180 380], [300 510]);
object06 = onesndx(imgdark, [300 260], [440 400]);



% Interact with the user for individual plots
% Light are in red, dark are in blue
disp('ENTER for segmentations, keep going...');
pause;

imshow(disksImage);
hold on;
plot(object01(:,1), object01(:,2), 'r.');
pause
plot(object02(:,1), object02(:,2), 'r.');
pause
plot(object03(:,1), object03(:,2), 'r.');
pause
plot(object04(:,1), object04(:,2), 'b.');
pause
plot(object05(:,1), object05(:,2), 'b.');
pause
plot(object06(:,1), object06(:,2), 'b.');
hold off

% Clear the local variables from the workspace,
% leaving the image and the circles
clear m n imgdark imglight lEdges dEdges ix jx
