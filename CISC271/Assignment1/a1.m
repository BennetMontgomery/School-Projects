function [Pvec, Nspace] = a1(plane1, plane2, plane3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   CISC 271 ASSIGNMENT 1   %
%Assignment 1 function takes%
%3 planes and returns a     %
%solution for a point of    %
%intersection between the 3 %
%planes. If more than one   %
%solution is possible,      %
%return the basis vectors of% 
%the nullspace of the planes%
%as well.                   %
%   Bennet Montgomery       %
%   Student # 20074049      %
%   2019-02-06              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%setting up data matrix A in the equation Ax = b for singularity checking
%later on
A = ([plane1(1:3); plane2(1:3); plane3(1:3)]);

%setting up plane equations in the form a_1x + a_2y + a_3z = -d for all
%input planes
syms x y z;
pleqn1 = (plane1(1) * x) + (plane1(2) * y) + (plane1(3) * z) == -plane1(4);
pleqn2 = (plane2(1) * x) + (plane2(2) * y) + (plane2(3) * z) == -plane2(4);
pleqn3 = (plane3(1) * x) + (plane3(2) * y) + (plane3(3) * z) == -plane3(4);

%solving equations and storing in a solution space
solutionSpace = solve([pleqn1, pleqn2, pleqn3], [x, y, z]);
%grabbing particular solution from solution space
Pvec = [solutionSpace.x; solutionSpace.y; solutionSpace.z];

%if data matrix A is singular:
if(rank(rref(A)) < 3)
    %find nullspace for data matrix A
    Nspace = null(A, 'r');
else
    %otherwise nullspace is trivial (return [0 0 0])
    Nspace = [0; 0; 0];
end