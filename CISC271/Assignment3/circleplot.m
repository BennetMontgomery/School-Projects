function circleplot(center, radius, color)
% CIRCLEPLOT(CENTER,RADIUS,COLOR) plots a circle at array
% coordinates CENTER, half-diameter RADIUS, using the
% COLOR character for the plot
%
% INPUTS:
%        CENTER - 1x2 array, in pixel coordinates, of the center
%        RADIUS - scalar, in pixel coordinates
%        COLOR  - single character for use in the PLOT function
% USAGE:
%        With an image already plotted by IMSHOW, use HOLD ON
%        prior to calling this function

% Circle resolution, in number of line segments
lnum = 300;

% Parametric array of THETA angles
tvec = linspace(0, 2*pi, lnum);

% Valid radius
r = abs(radius);

% X and Y circle points from the parametric equation
x = r*cos(tvec) + center(1);
y = r*sin(tvec) + center(2);

% Plot the center as an asterisk, circle as connected lines
plot(center(1), center(2), strcat(color(1), '*'), ...
     x, y, strcat(color(1), '-'), 'LineWidth', 3);
