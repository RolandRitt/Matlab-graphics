%% Test plotvline
% 
% Description : 
%
%
% Author : 
%    Roland Ritt
%
% History :
% \change{1.0}{08 June 2017}{Original}
%
% --------------------------------------------------
% (c) 2017, Roland Ritt
% Chair of Automation, University of Leoben, Austria
% email: automation@unileoben.ac.at
% url: automation.unileoben.ac.at
% --------------------------------------------------
clc
clear all;
close all hidden;
x = linspace(0,2*pi, 100)';

y1 = sin(x) + randn(size(x))*0.1;
y2 = cos(x) + randn(size(x))*0.1;

Y = [y1 y2];

figure;
plot(x,y1);
plotvline([0.1, 1, 2]')
figureGen;
H = plotMulti(x, Y);
plotvline([0.1, 1, 2]', 'Axes', H ,'Marker', 'o');


