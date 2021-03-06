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
nrPts = 150;
u = linspace(-1,1,nrPts)';
%
degree = 5;
%
try
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

F = figureGen;

%

for i=1:degree
   D{i} =  B(:,randi([1,degree], randi([1,degree]),1));
end
figH = plotMulti( u, D, xLabel, yLabels, 'LineWidth', 1.5 );

