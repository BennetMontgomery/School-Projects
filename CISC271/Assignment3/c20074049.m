function c20074049()
%%%%%%%%%%%%%%%%%%%%%%%%%
%       Assignment 3    %
% IMPORTANT: PROGRAM    %
%ASSUMES IMAGES AND TXT %
%FILES CAN BE LOADED    %
%FROM LOCAL DIRECTORY   %
%"./data/"              %
% Bennet Montgomery     %
% 20074049              %
% 2019-03-28            %
%%%%%%%%%%%%%%%%%%%%%%%%%

%loading disksimage.png
disksImage= imread('data/disksimage.png');

%loading data for first 6 objects (disks in disksimage.png)
object01 = load('data/object01.txt');
object02 = load('data/object02.txt');
object03 = load('data/object03.txt');
object04 = load('data/object04.txt');
object05 = load('data/object05.txt');
object06 = load('data/object06.txt');

%calculating centers, radii, and error of least squares formulation for
%disks
[d1center, d1radius, d1error] = circlefit(object01);
[d2center, d2radius, d2error] = circlefit(object02);
[d3center, d3radius, d3error] = circlefit(object03);
[d4center, d4radius, d4error] = circlefit(object04);
[d5center, d5radius, d5error] = circlefit(object05);
[d6center, d6radius, d6error] = circlefit(object06);

%setting disksImage as target figure
imshow(disksImage);
hold on
%plotting disks least squares approximations
circleplot(d1center, d1radius, 'r.');
circleplot(d2center, d2radius, 'r.');
circleplot(d3center, d3radius, 'r.');
circleplot(d4center, d4radius, 'r.');
circleplot(d5center, d5radius, 'r.');
circleplot(d6center, d6radius, 'r.');
hold off
%saving figure for report
print -depsc figure1

%without this pause inserted, not enough time passes between image
%selection for the figures, leading to the circles for figure 2 being drawn
%before MATLAB switches to the pill image. Bizarre. Happens on my machine,
%but not always.
pause(0.1)

figure
%loading pillimage
pillImage= imread('data/pillsetgray.png');

%loading pill object data
object07 = load('data/object07.txt');
object08 = load('data/object08.txt');
object09 = load('data/object09.txt');
object10 = load('data/object10.txt');

%setting pillimage as target figure
imshow(pillImage);

%calculating centers, radii, and error of least squares formulation for
%office supplies
[d7center, d7radius, d7error] = circlefit(object07);
[d8center, d8radius, d8error] = circlefit(object08);
[d9center, d9radius, d9error] = circlefit(object09);
[d10center, d10radius, d10error] = circlefit(object10);

hold on
%plotting least squares approximations for office supplies
circleplot(d7center, d7radius, 'b.');
circleplot(d8center, d8radius, 'b.');
circleplot(d9center, d9radius, 'b.');
circleplot(d10center, d10radius, 'b.');
hold off
print -depsc figure2

%outputting calculated RMSEs for report
disp('RMSE of object 1:')
disp(d1error)
disp('RMSE of object 2:')
disp(d2error)
disp('RMSE of object 3:')
disp(d3error)
disp('RMSE of object 4:')
disp(d4error)
disp('RMSE of object 5:')
disp(d5error)
disp('RMSE of object 6:')
disp(d6error)
disp('RMSE of object 7:')
disp(d7error)
disp('RMSE of object 8:')
disp(d8error)
disp('RMSE of object 9:')
disp(d9error)
disp('RMSE of object 10:')
disp(d10error)
end

%backsubstitution function for QR decomposition based solution
function [solution] = backsubstitution(R1, y)
[m, n] = size(R1);

%preallocating solution vector
%indices (1:n-1, 1) are center approximation, index (n, 1) is sigma approx.
solution = zeros(n, 1);

%performing back substitution (general case solution)
for i = m:-1:1
    solution(i, 1) = y(i, 1);
    for j = i+1:n
        solution(i, 1) = solution(i, 1) - R1(i, j)*solution(j, 1);
    end
    solution(i, 1) = solution(i, 1)/R1(i, i);
end
end

%circlefit solution
function [center, radius, rmserr] = circlefit(xydata)
% Problem size
[m, n] = size(xydata);

% Set up data matrix A
onesvec = ones(m, 1);
A = [-2.*(xydata) onesvec];

% Set up data vector b
b = zeros(m, 1);
for i = 1:m
    b(i, 1) = -1*(dot(transpose(xydata(i, :)), transpose(xydata(i, :))));
end

% Find basic coefficients
[Q1,R1] = qr(A, 0);

y = transpose(Q1)*b;
coeff = backsubstitution(R1, y);

% Extract coefficients for the best fit
%center approximation (g hat) is the first n values of coeff
center = coeff(1:n, 1);
%radius approximation based on eqn (3) from assignment 3 appendix
radius = sqrt(dot(center, center) - coeff(end));

% Evaluate the fit as the RMS error
%preallocating e vec
errorvec = zeros(m, 1);
for i = 1:m
    errorvec(i, 1) = norm(transpose(xydata(i, :)) - center) - radius;
end

%performing RMSE calculation on e vec
rmserr = sqrt((norm(errorvec)^2)/m);
end
