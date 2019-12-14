function [Pvec, Nspace] = a12(plane1, plane2, plane3)

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

%setting up augmented matrix A of plane inputs
A = ([plane1; plane2; plane3]);
%getting rref form of A
R = rref(A);
%getting rank of planes
arank = rank(R);

if(arank == 0)
    Pvec = [0, 0, 0];
    Nspace = null([plane1(1:3); plane2(1:3); plane3(1:3)], 'r');
elseif(arank == 1)
    if(R(1, 1) == 1)
        Pvec = [-R(1, 4); 0; 0];
    elseif(R(1, 2) == 1)
        Pvec = [0; -R(1, 4); 0];
    else %R(1, 3) == 1
        Pvec = [0; 0; -R(1, 4)];
    end
    Nspace = null([plane1(1:3); plane2(1:3); plane3(1:3)], 'r');
elseif(arank == 2)
    if(R(1, 1) == 0)
        z = -R(2, 4);
        y = -R(1, 4);
        x = 0;
    elseif(R(2, 2) == 0)
        z = -R(2, 4);
        y = 0;
        x = -R(1, 4);
    else
        z = 0;
        y = -R(2, 4);
        x = -R(1, 4);
    end
    Pvec = [x; y; z];
    Nspace = null([plane1(1:3); plane2(1:3); plane3(1:3)], 'r');
elseif(arank == 3)
    x = -R(1,4);
    y = -R(2, 4);
    z = -R(3, 4);
    Pvec = [x; y; z];
    Nspace = [0; 0; 0];
end