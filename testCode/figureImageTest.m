%% test the figureImage function
%
% This code tests the figureImage function
%
% (c) Paul O'Leary 2016
%
%%
close all;
clear;
%%
[pic, map] = imread( 'CDF-TwoMen.jpg' );
%
fig1 = figureImage( pic, 10, map);
figureSave( gcf, 'CDF' );