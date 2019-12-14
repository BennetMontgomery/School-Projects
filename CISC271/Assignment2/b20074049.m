%loading pricing data into data matrices z1 & z2
z1 = load('z1.dat');
z2 = load('z2.dat');

%SECTION 1: generating approximation matrix

%setting up PCA for first dataset, dividing z1 into SVD relevant parts:
% uvecmat1 = U, sdiag1 = Sigma, meanvec1 = M
[sdiag1, meanvec1, uvecmat1] = pcaprelim(z1);
sums1 = sum(sdiag1);
%preallocating array for rho values for each value of k in rho = t_k/t_n
ps1 = zeros(size(sdiag1, 1), 1);

%as above, but for z2
[sdiag2, meanvec2, uvecmat2] = pcaprelim(z2);
sums2 = sum(sdiag2);
ps2 = zeros(size(sdiag2, 1), 1);


%filling rho value arrays, performing rho calculation for all k between
%1 and max number of k
for i = 1:size(sdiag1, 1)
    ps1(i, 1) = 100 * sum(sdiag1(1:i))/sums1;
    
    ps2(i, 1) = 100 * sum(sdiag2(1:i))/sums2;
end

%plotting rho values
plot(1:18, ps1, 1:18, ps2, '--'); 
title("Proportion of Coverage by Number of Eigenvalues");
xlabel("value of k in calculation of rho");
ylabel("approximation coverage in %");
legend({"z1", "z2"}, "Location", "northwest");
%generating eps file for inclusion in report
print -deps figure1


%preallocating approximation matrix for first dataset
D1 = zeros(size(z1, 1), size(z1, 2));
%betas1 = [];

%preallocating approximation matrix for second dataset
D2 = zeros(size(z2, 1), size(z2, 2));
%betas2 = [];

for i = 1:size(z1, 2)
    %General concern: never used approxcomp in analysis
    [approxcomp, approxvec] = pcaapprox(z1(:,i), 4, meanvec1, uvecmat1);
    D1(:, i) = approxvec;
    %betas1 = [betas1 approxcomp];
    
    [approxcomp, approxvec] = pcaapprox(z2(:,i), 3, meanvec2, uvecmat2);
    D2(:, i) = approxvec;
    %betas2 = [betas2 approxcomp];
end

%Section 2: Calculating error with RMSE

%generating matrix of residuals between generated and real values squared
%for D1 and z1
sqresiduals1 = (D1 - z1).^2;
%preallocating array for RMSE values of commodities in z1
rmses1 = zeros(1, size(z1, 2));

%as above but for z2 and D2
sqresiduals2 = (D2 - z2).^2;
rmses2 = zeros(1, size(z2, 2));

%filling RMSE arrays
for i = 1:size(sqresiduals1, 2)
    rmses1(1, i) = sqrt(mean(sqresiduals1(:,i)));
    rmses2(1, i) = sqrt(mean(sqresiduals2(:,i)));
end

%plotting RMSEs
figure
plot(1:18, rmses1, 1:18, rmses2, '--');
title("RMSE by Commodity");
xlabel("commodity in zn");
ylabel("RMSE value");
legend({"z1", "z2"}, "Location", "northwest");
%generating eps file for inclusion in report
print -deps figure2

%plotting meanvectors
figure
plot(1:100, meanvec1, 1:100, meanvec2, '--');
title("Mean Commodity Values by Quarter");
xlabel("quarter since 1990q1");
ylabel("average commodity price index by group");
legend({"z1", "z2"}, "Location", "northwest");
%generating eps file for inclusion in report
print -deps figure3

meanz1error = mean(rmses1);
meanz2error = mean(rmses2);

%Section 3: Functions for PCA taken from Dr. Ellis' notes on PCA

function [sdiag, meanvec, uvecmat] = pcaprelim(Z)
    % FUNCTION [SDIAG, MEANVEC, UVECMAT] = PCAPRELIM(Z)
    % performs the preliminary Principal Components Analysis
    % (PCA) of Z, a matrix in which the data are
    % represented as columns. PCAPRELIM returns:
    % SDIAG   - singular values of the PCA, in decreasing order
    % MEANVEC - the mean vector of the initial data
    % UVECMAT - left singular vectors of the PCA, as column vectors
    
    % Find the mean vector and form it into a matrix
    [m, n] = size(Z);
    meanvec = mean(Z, 2);
    M = meanvec * ones(1, n);
    
    % Find the difference matrix
    D = Z - M;
    
    % Find the left singular vectors as a matrix and
    % the singular values as a vector
    [uvecmat, Smat, Vvecs] = svd(D, 'econ');
    sdiag = diag(Smat);
end

function [approxcomp, approxvec] = pcaapprox(new_data,  ...
                                            approxnum,  ...
                                            meanvec,    ...
                                            uvecmat)
    % [APPROXCOMP,APPROXVEC]=PCAAPPROX(NEW_DATA, APPROXNUM,
    %                                  MEANVEC, UVECMAT)
    % approximates new data based on a  Principal Components Analysis
    % (PCA) of initial data.  Inputs are:
    % NEW_DATA -  a signal to be approximated, as a column vector
    % APPROXNUM - a scalar giving the order of the approximation
    % MEANVEC -   the PCA mean vector (from PCAPRELIM)
    % UVECMAT -   the singular vectors of the PCA (from PCAPRELIM)
    %
    % Return values are:
    % APPROXCOMP - the components as a row vector of scalars
    % APPROXVEC -  the approximation of the new data as a vector
    
    % Set up the initial and return values
    diffvec = new_data - meanvec;
    approxcomp = zeros(approxnum, 1);
    approxvec = meanvec;
    
    % Loop through the eigenvectors, finding the components
    % and building the approximation
    for i = 1:approxnum
        uvec = uvecmat(:,i);
        beta = dot(diffvec, uvec);
        approxcomp(i, 1) = beta;
        approxvec = approxvec + beta*uvec;
    end
end