%% Test the poltMulti function
%
% This script test the plotMulti function.
%
% (c) Paul O'Leary 2016

%
%%
close all;
clear;
%%
nrPts = 200;
u = linspace(0,1,nrPts)';
%
degree = 8;
%
try
B = bernsteinBasis( u, degree );
catch
    B = vander(u);
    B = B(:,end-degree+1:end);
end
%
xLabel = '$$t \, [s]$$';
for k=1:degree+1
    yLabels{k} = ['$$b_',int2str(k),'$$'];
end;
F = figureGen;
plotMulti( u, B, xLabel, yLabels );
