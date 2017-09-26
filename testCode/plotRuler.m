%% Script to generate a figure with a ruler
%
% (c) Paul O'Leary 2016
%
%%
close all;
clear;
%%
% Minimum and maximum values as integers for the generation 
% of the ruler
xMin = -4;
xMax = 3;
%

markerRange = xMin:xMax;
%
width = 8;
majorTickLength = width / 50;
halfTickLength = 0.7 * majorTickLength;
minorTickLength = 0.3 * majorTickLength;
%
textOffset = 0.18;
%
fig1 = figureGen( 6, width );
a(1) = axes( 'Position', [0,0,1,1] );
%
% Plot the x axis
%
hg = hggroup;
%
plot( [xMin, xMax], [0,0], 'k', hg);
axis tight;
axis off;
axis equal;
hold on;
%
% Plot major ticks
%
nrTicks = length( markerRange );
for k=1:nrTicks
    at = markerRange( k );
    plot( [at, at], [0, -majorTickLength], 'k', hg);
    text( at, - majorTickLength - textOffset,...
        int2str(markerRange(k)),...
        'HorizontalAlignment', 'Center', hg);
end;
%
% Plot half ticks
%
halfMarker = markerRange(1:end-1) +...
    (markerRange(2) - markerRange(1))/2;
nrTicks = length( halfMarker );
for k=1:(nrTicks-1)
    at = halfMarker( k );
    plot( [at, at], [0, -halfTickLength], 'k', hg);
end;
%
% Plot minor ticks
%
minorMarker = sort( [markerRange, halfMarker] );
nrTicks = length( minorMarker );
for k=1:(nrTicks-1)
    at = minorMarker( k );
    for j = 1:4
        plot( [at, at] + j * 0.1, [0, -minorTickLength], 'k', hg);
    end;
end;
%
axisRange = axis;
axis( [xMin - 0.25, xMax + 0.25, axisRange(3:4)] );
%
