function [V]=vif(X)
% function from https://www.mathworks.com/matlabcentral/fileexchange/60551-vif-x

%vif() computes variance inflation coefficients  
%VIFs are also the diagonal elements of the inverse of the correlation matrix [1], a convenient result that eliminates the need to set up the various regressions
%[1] Belsley, D. A., E. Kuh, and R. E. Welsch. Regression Diagnostics. Hoboken, NJ: John Wiley & Sons, 1980.

R0 = corrcoef(X); % correlation matrix
V=diag(inv(R0))';