function ijmat = onesndx(binimage, cornerll, cornerur)
% IJMAT=ONESNDX(BINIMAGE,CORNERLL,CORNERUR) finds the
% (I,J) indexes of 1 values in the binary image BINIMAGE
% from the lower-left CORNERLL to the upper-right CORNERUR
% rectangle.
%
% INPUTS:
%        BINIMAGE - MxN binary image, usually logical values
%        CORNERLL - 1x2 array of (i,j) indexes for lower left
%        CORNERUR - 1x2 array of (i,j) indexes for upper right
% OUTPUT:
%        IJMAT    - Kx2 array, possibly empty, of pixel indexes

% Problem size
[m, n] = size(binimage);

% Ensure that only valid pixels are used
rowmin = max(1, cornerll(1));
rowmax = min(m, cornerur(1));
colmin = max(1, cornerll(2));
colmax = min(n, cornerur(2));


% Set up and scan the image; will need to swap indexes to
% convert from image coordinates to pixel coordinates
ijmat = [];
for ix=rowmin:rowmax;
  for jx=colmin:colmax;
    if binimage(ix, jx);
      ijmat(end+1, :)=[jx ix];
    end;
  end;
end
