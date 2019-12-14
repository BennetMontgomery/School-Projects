function d20074049
% CISC271, Winter 2019, Assignment #4
%%%%%%%%%%%%%%%%%%%%%%%%%
% Bennet Montgomery     %
% Student #: 20074049   %
% 2019-04-11            %
%%%%%%%%%%%%%%%%%%%%%%%%%


% EXAMPLE: Load the data for Question 1
xpetal = load('xpetal.txt');
ypetal = load('ypetal.txt');

% EXAMPLE: Plot the data
plotclass2d(xpetal, ypetal);
print -depsc plot1

figure
hold on
%rng line is necessary or kmeans sometimes doesn't work (?)
rng(1)
%performing kmeans classification. idx is classification matrix, C is
%classification centers
[idx, C] = kmeans(xpetal', 2);

%plotting classification centers as large black *
plot(C(1,1), C(1,2), 'r*', 'MarkerSize', 20, 'LineWidth', 2, 'MarkerEdge', [0, 0, 0]);
plot(C(2,1), C(2,2), 'r*', 'MarkerSize', 20, 'LineWidth', 2, 'MarkerEdge', [0, 0, 0]);

%creating idx copy converted to -1s and 1s (idx generated as 1s and 2s by
%kmeans function
idxadj = ones(size(idx,1),1);
for i = 1:size(idx,1)
     if idx(i) == 1 
        idxadj(i) = -1;
    else
        idxadj(i) = 1;
    end
end
%plotting classifications
plotclass2d(xpetal, idxadj);
hold off
print -depsc plot2

%generating table for report
Misses = [];
PredictedValue = [];
ActualValue = [];
data = xpetal';

for i = 1:size(idxadj,1)
    if idxadj(i) ~= ypetal(i)
        Misses = [Misses; data(i,:)];
        PredictedValue = [PredictedValue; idxadj(i)];
        ActualValue = [ActualValue; ypetal(i)];
    end
end

KMeansMiss = table(Misses, PredictedValue, ActualValue)

figure
hold on
%plotting base data with label for perceptron algorithm plot
plotclass2d(xpetal, ypetal);
%generating perceptron algorithm hyperplane
[augmentedVec, i_used] = linsepiterate(rand(3,1), xpetal, ypetal)
%plotting perceptron hyperplane on plot in green
plotline(augmentedVec, 'g');
hold off
print -depsc plot4

figure
hold on
%plotting base data with labels for SVM algorithm plot
plotclass2d(xpetal, ypetal);
%applying SVM
svmVec = svm271(xpetal, ypetal)
%plotting SVM line in yellow
plotline(svmVec, 'y');
hold off
print -depsc plot5

%loading second dataset
xdata = load('xdata.txt');
ylabels = load('ylabels.txt');

figure
%plotting second dataset for reference
plotclass2d(xdata, ylabels);
print -depsc plot6

figure
hold on
%generating 3d projection via formula [x y x*y]
projd = ones(1, size(xdata, 2));
for i = 1:size(projd, 2)
    projd(i) = xdata(1, i) * xdata(2, i);
end
d3projection = [xdata; projd];

%plotting 3d projection
plotclass3d(d3projection, ylabels);
%generating hyperplane via SVM
planevec = svm271(d3projection, ylabels)
%plotting hyperplane
plotplane(planevec);
hold off

end

function [v_final, i_used] = linsepiterate(vvec, zdata, yvec)
% [V_FINAL,I_USED]=LINSEPLEARN(VINIT,BVAL,ZDATA,YVEC)
% uses the Percetron Algorithm to linearly separate training vectors
% INPUTS:
%         VVEC    - (M+1)-D augmented weight vector
%         ZDATA   - MxN  data matrix
%         YVEC    - N-D known classes, +1 or -1
% OUTPUTS:
%         V_FINAL - M-D new estimated weight vector
%         I_USED  - scalar number of iterations used
% ALGORITHM:
%         Serialized form of perceptron gradient descent

% Internal constant: maximum iterations to use
imax = 1000;

% Problem size
[m, n] = size(zdata);

% Create the augmented vectors from the data vectors
zmat = [zdata ; ones(1, n)];

% Set up the iteration for the weight vector and bias
v_est = vvec;

% Loop a limited number of times
for i_used=0:imax
  % Assume that the final weight is the current estimate
  v_final = v_est;
  
  % Score the current estimate of the weight vector
  missed = 0;
  for jx=1:n
    %following is an implementation of algorithm from class 30 notes
    u = v_est' * zmat(:, jx);
    if ((u > 0) && (yvec(jx) < 0))
        v_est = v_est - zmat(:, jx);
        missed = missed + 1;
    elseif ((u < 0) && (yvec(jx) > 0))
        v_est = v_est + zmat(:, jx);
        missed = missed + 1;
    end
  end

  % Stop if the current estimate has converged
  if (missed==0)
    v_final = v_est;
    break;
  end
  
end
end


function plotclass2d(xmatrix, yvector)
% PLOTCLASS2D(XMATRIX,YVECTOR) plots 2D training vectors
% for binary supervised classification
%
% INPUTS:
%        XMATRIX - 2xN set of column vectors
%        YVECTOR - Nx1 classification as +1 or -1
% OUTPUT:
%        none
% SIDE EFFECTS:
%        Plot into the current window. +1 training vectors
%        are shown as blue "+", -1 training vectors are
%        shown as red circles. Axes are slightly adjusted to
%        improve legibility.

% Problem size
[m, n] = size(xmatrix);

% Plot the training vectors with distinct symbols
plot(xmatrix(1,yvector<0), xmatrix(2,yvector<0), 'ro', ...
     xmatrix(1,yvector>0), xmatrix(2,yvector>0), 'b+');
axdf=axis;
axis(axdf+[-1 +1 -1 +1]);
axis('equal');
end

function plotclass3d(xmatrix, yvector)
% PLOTCLASS3D(XMATRIX,YVECTOR) plots 3D training vectors
% for binary supervised classification
%
% INPUTS:
%        XMATRIX - 2xN set of column vectors
%        YVECTOR - Nx1 classification as +1 or -1
% OUTPUT:
%        none
% SIDE EFFECTS:
%        Plot into the current window. +1 training vectors
%        are shown as blue "+", -1 training vectors are
%        shown as red circles. Axes are slightly adjusted to
%        improve legibility.

% Problem size
[m, n] = size(xmatrix);

% Plot the training vectors with distinct symbols
plot3(xmatrix(1,yvector<0), xmatrix(2,yvector<0), xmatrix(3,yvector<0), 'ro', ...
      xmatrix(1,yvector>0), xmatrix(2,yvector>0), xmatrix(3,yvector>0), 'b+');
end

function plotline(vvec, color)
% PLOTLINE(VVEC,COLOR) plots a separating line
% into an existing figure
% INPUTS:
%        VVEC   - (M+1) augmented weight vector
%        COLOR  - character, color to use in the plot
% ALGORITHM:
% Intersect the line with the boundary of the current plot

% Current axis settings
axin = axis();

% Matrices of XY vectors that are on the input line and
% bounding lines

Alr = [vvec(1:2)' ; 1 0];
Atb = [vvec(1:2)' ; 0 1];

% Data vectors that all lines must satisfy
bl = [-vvec(3) ; axin(1)];
br = [-vvec(3) ; axin(2)];
bb = [-vvec(3) ; axin(3)];
bt = [-vvec(3) ; axin(4)];

% Special cases: input line is horizontal or vertical
if cond(Alr) > 1e5
  xs = Atb\bb;
  xe = Atb\bt;
elseif cond(Atb) > 1e5
  xs = Alr\bl;
  xe = Alr\br;
else
  % Solutions of simultaneous lines
  xl = Alr\bl;
  xr = Alr\br;
  xb = Atb\bb;
  xt = Atb\bt;

  % Select left/right or bottom/top pair,
  % whichever specifies a longer segment
  if norm(xl-xr)>norm(xb-xt)
    xs = xl;
    xe = xr;
  else
    xs = xb;
    xe = xt;
  end
end

% Plot the line and re-set the axis to its original
hold on;
plot([xs(1) xe(1)], [xs(2) xe(2)], strcat(color, '-'));
hold off;
axis(axin);
end

function plotplane(vvec)
% PLOTPLANE(VVEC) plots the 3D plane specified by
% the augmented vector VVEC
%
% INPUT:
%       VVEC - 4x1 vector as [normal ; bias]
% ALGORITHM:
%       Calls the INRIA code "drawPlane3D"

% Find a reference vector on the plane
pvec  = vvec(1:3)/dot(vvec(1:3), vvec(1:3))*(-vvec(4));

% Find basis (direction) vectors for the relevant sub-space
bvecs = ortc271(vvec(1:3));

% Call the INRIA function to do the work
drawPlane3d([pvec' bvecs(:,1)' bvecs(:,2)']);
end

function vspace = ortc271(amat)
% VSPACE=ORTC271(AMAT) finds the orthogonal complement
% of matrix AMAT using the QR decomposition
%
% INPUT:
%        AMAT   - MxN input matrix of rank K
%
% OUTPUT:
%        VSPACE - Mx(M-K) matrix
%                 If AMAT is full rank, VSPACE is a zero vector

% Problem size
[m, n] = size(amat);
k = rank(amat);

if k>=m
  % AMAT is full rank, return zero vector
  vspace = zeros(m, 1);
else
  % QR decomposition
  [q, r] = qr(amat);
  
  % Extract the relevant submatrix
  vspace = q(:, (k+1):m);
end
end

function varargout = drawPlane3d(plane, varargin)
%DRAWPLANE3D Draw a plane clipped in the current window
%
%   drawPlane3d(plane)
%   plane = [x0 y0 z0  dx1 dy1 dz1  dx2 dy2 dz2];
%
%   See also
%   planes3d, createPlane
%
%   Example
%   p0 = [1 2 3];
%   v1 = [1 0 1];
%   v2 = [0 -1 1];
%   plane = [p0 v1 v2];
%   axis([-10 10 -10 10 -10 10]);
%   drawPlane3d(plane)
%   drawLine3d([p0 v1])
%   drawLine3d([p0 v2])
%   set(gcf, 'renderer', 'zbuffer');
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 17/02/2005.
%

%   HISTORY
%   2008-10-30 replace intersectPlaneLine by intersectLinePlane, add doc
%   2010-10-04 fix a bug for planes touching box by one corner
%   2011-07-19 fix a bug for param by Xin KANG (Ben)
% 

param = {'m'};
if ~isempty(varargin)
  param = varargin;
end

lim = get(gca, 'xlim');
xmin = lim(1);
xmax = lim(2);
lim = get(gca, 'ylim');
ymin = lim(1);
ymax = lim(2);
lim = get(gca, 'zlim');
zmin = lim(1);
zmax = lim(2);


% line corresponding to cube edges
lineX00 = [xmin ymin zmin 1 0 0];
lineX01 = [xmin ymin zmax 1 0 0];
lineX10 = [xmin ymax zmin 1 0 0];
lineX11 = [xmin ymax zmax 1 0 0];

lineY00 = [xmin ymin zmin 0 1 0];
lineY01 = [xmin ymin zmax 0 1 0];
lineY10 = [xmax ymin zmin 0 1 0];
lineY11 = [xmax ymin zmax 0 1 0];

lineZ00 = [xmin ymin zmin 0 0 1];
lineZ01 = [xmin ymax zmin 0 0 1];
lineZ10 = [xmax ymin zmin 0 0 1];
lineZ11 = [xmax ymax zmin 0 0 1];


% compute intersection points with each plane
piX00 = intersectLinePlane(lineX00, plane);
piX01 = intersectLinePlane(lineX01, plane);
piX10 = intersectLinePlane(lineX10, plane);
piX11 = intersectLinePlane(lineX11, plane);
piY00 = intersectLinePlane(lineY00, plane);
piY01 = intersectLinePlane(lineY01, plane);
piY10 = intersectLinePlane(lineY10, plane);
piY11 = intersectLinePlane(lineY11, plane);
piZ00 = intersectLinePlane(lineZ00, plane);
piZ01 = intersectLinePlane(lineZ01, plane);
piZ10 = intersectLinePlane(lineZ10, plane);
piZ11 = intersectLinePlane(lineZ11, plane);

% concatenate points into one array
points = [...
    piX00;piX01;piX10;piX11; ...
    piY00;piY01;piY10;piY11; ...
    piZ00;piZ01;piZ10;piZ11;];

% check validity: keep only points inside window
ac = 1e-14;
vx = points(:,1)>=xmin-ac & points(:,1)<=xmax+ac;
vy = points(:,2)>=ymin-ac & points(:,2)<=ymax+ac;
vz = points(:,3)>=zmin-ac & points(:,3)<=zmax+ac;
valid = vx & vy & vz;
pts = unique(points(valid, :), 'rows');

% If there is no intersection point, escape.
if size(pts, 1)<3
    disp('plane is outside the drawing window');
    return;
end

% the two spanning lines of the plane
d1 = plane(:, [1:3 4:6]);
d2 = plane(:, [1:3 7:9]);

% position of intersection points in plane coordinates
u1 = linePosition3d(pts, d1);
u2 = linePosition3d(pts, d2);

% reorder vertices in the correct order
ind = convhull(u1, u2);
ind = ind(1:end-1);

% draw the patch
h = patch(pts(ind, 1), pts(ind, 2), pts(ind, 3), param{:});

% return handle to plane if needed
if nargout>0
    varargout{1}=h;
end
end

function pos = linePosition3d(point, line)
%LINEPOSITION3D Return the position of a 3D point projected on a 3D line
%
%   T = linePosition3d(POINT, LINE)
%   Computes position of point POINT on the line LINE, relative to origin
%   point and direction vector of the line.
%   LINE has the form [x0 y0 z0 dx dy dy],
%   POINT has the form [x y z], and is assumed to belong to line.
%   The result T is the value such that POINT = LINE(1:3) + T * LINE(4:6).
%   If POINT does not belong to LINE, the position of its orthogonal
%   projection is computed instead. 
%
%   T = linePosition3d(POINT, LINES)
%   If LINES is an array of NL lines, return NL positions, corresponding to
%   each line.
%
%   T = linePosition3d(POINTS, LINE)
%   If POINTS is an array of NP points, return NP positions, corresponding
%   to each point.
%
%   See also:
%   lines3d, createLine3d, distancePointLine3d, projPointOnLine3d
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 17/02/2005.
%

%   HISTORY
%   05/01/2007 update doc
%   28/10/2010 change to bsxfun calculation for arbitrary input sizes
%       (Thanks to Sven Holcombe)
%   03/31/2014 reversed bsxfun calculation for back compatibility
%       (by R. E. Ellis)

% vector from line origin to point
for i=1:size(point,1)
  dp(i,:) =  point(i,:) - line(:,1:3);
  end

% direction vector of the line
vl = line(:, 4:6);

% precompute and check validity of denominator
denom = sum(vl.^2, 2);
invalidLine = denom < eps;
denom(invalidLine) = 1;

% compute position using dot product normalized with norm of line vector.
for i=1:size(dp,1)
  pos(i,:) = dot(dp(i,:), vl)/denom;
  end

% position on a degenerated line is set to 0
pos(invalidLine) = 0;
end

function vvec = svm271(zmat, yclass)
% VVEC=SVM271(ZMAT,YCLASS) linearly separates
% data in ZMAT according to classes YCLASS, using
% the SVM solver
% INPUTS:
%         ZMAT - MxN data matrix
%         DVEC - N-D desired classes, +1 or -1
% OUTPUTS:
%         VVEC - (M+1)-D weight vector of separating hyperplane
% ALGORITHM:
%         Call the Matlab function FITCSVM in R2017a, which
%         was the CASLAB installation for Winter 2018. Use a 
%         linear kernel with unscaled data and reconstruct the
%         separating hyperplane from the Beta vector and
%         Bias scalar.

% Call the Matlab function for linear SVM
svmObj = fitcsvm(zmat', yclass);

% Augmented weight vector of the separating hyper-plane
vvec = [svmObj.Beta ; svmObj.Bias];
end

function point = intersectLinePlane(line, plane, varargin)
%INTERSECTLINEPLANE Intersection point between a 3D line and a plane
%
%   PT = intersectLinePlane(LINE, PLANE)
%   Returns the intersection point of the given line and the given plane.
%   LINE:  [x0 y0 z0 dx dy dz]
%   PLANE: [x0 y0 z0 dx1 dy1 dz1 dx2 dy2 dz2]
%   PT:    [xi yi zi]
%   If LINE and PLANE are parallel, return [NaN NaN NaN].
%   If LINE (or PLANE) is a matrix with 6 (or 9) columns and N rows, result
%   is an array of points with N rows and 3 columns.
%   
%   PT = intersectLinePlane(LINE, PLANE, TOL)
%   Specifies the tolerance factor to test if a line is parallel to a
%   plane. Default is 1e-14.
%
%   Example
%     % define horizontal plane through origin
%     plane = [0 0 0   1 0 0   0 1 0];
%     % intersection with a vertical line
%     line = [2 3 4  0 0 1];
%     intersectLinePlane(line, plane)
%     ans = 
%        2   3   0
%     % intersection with a line "parallel" to plane
%     line = [2 3 4  1 2 0];
%     intersectLinePlane(line, plane)
%     ans = 
%       NaN  NaN  NaN
%
%   See also:
%   lines3d, planes3d, points3d, clipLine3d
%
%   ---------
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 17/02/2005.
%

%   HISTORY
%   24/11/2005 add support for multiple input
%   23/06/2006 correction from Songbai Ji allowing different number of
%       lines or plane if other input has one row
%   14/12/2006 correction for parallel lines and plane normals
%   05/01/2007 fixup for parallel lines and plane normals
%   24/04/2007 rename as 'intersectLinePlane'
%   11/19/2010 Added bsxfun functionality for improved speed (Sven Holcombe)
%   01/02/2011 code cleanup, add option for tolerance, update doc
%   03/31/2014 reversed bsxfun calculation for back compatibility
%       (by R. E. Ellis)


% extract tolerance if needed
tol = 1e-14;
if nargin > 2
    tol = varargin{1};
end

% unify sizes of data
nLines  = size(line, 1);
nPlanes = size(plane, 1);

% N planes and M lines not allowed 
if nLines ~= nPlanes && min(nLines, nPlanes) > 1
    error('MatGeom:geom3d:intersectLinePlane', ...
        'Input must have same number of rows, or one must be 1');
end

% plane normal
n = cross(plane(:,4:6), plane(:,7:9));

% difference between origins of plane and line
dp = plane(:, 1:3) - line(:, 1:3);

% dot product of line direction with plane normal
denom = dot(n, line(:,4:6));

% relative position of intersection point on line (can be inf in case of a
% line parallel to the plane)
t = dot(n, dp) ./ denom;

% compute coord of intersection point
point = line(:,1:3) +  t*line(:,4:6);

% set indices of line and plane which are parallel to NaN
par = abs(denom) < tol;
point(par,:) = NaN;
end
