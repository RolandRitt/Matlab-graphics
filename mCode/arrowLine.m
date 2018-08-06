function [L, H] = arrowLine( x, y, lineType, scale )
%
% Purpose : This function draws an arrow in a figure
%
% Use (syntax):
%   [L, H] = arrow( x, y, lineType, scale );
%
% Input Parameters :
%   x,y: The start and end coordainates of the arrow
%   linetype: see plot for iinformation
%   scale: the relative size of the arrow head
%
% Return Parameters :
%   L: handel to the line
%   H: handel the the arrow head
%
% Description and algorithms:
%
% References : 
%
% Author :  Paul O'Leary
% Date :    17. June 2007
% Version : 1.0
%
% (c) 2009 Paul O'Leary, Chair of Automation, University of Leoben, Leoben, Austria
% email: automation@unileoben.ac.at, url: automation.unileoben.ac.at
%
% History:
%   Date:           Comment:
%

nInputs = nargin;
nOutputs = nargout;
%
range = axis;
dx = range(1) - range(2);
dy = range(3) - range(4);
diag = sqrt( dx^2 + dy^2 );
%
if nInputs < 4
    scale = 0.02;
end;
%
arrowL = scale * diag;
arrowW = arrowL / 4;
%
colour = lineType(1);
%
if (nOutputs >= 1)
    L = plot( x, y, lineType );
else
    plot( x, y, lineType );
end;
%
headAtX = x(end);
headAtY = y(end);
%
x1 = x(end);
x2 = x(end-1);
%
y1 = y(end);
y2 = y(end-1);
%
len = sqrt( (x1-x2)^2 + (y1-y2)^2);
%
cp = (x1 - x2)/len;
sp = (y1 - y2)/len;
%
R = [cp, -sp, 0; sp, cp, 0; 0,0,1];
T = [1,0,x1; 0,1,y1; 0,0,1];
%
arrow = [ 0, -arrowL, -arrowL, 0;...
          0, -arrowW,  arrowW, 0;...
          1,    1,        1,   1];
%
arrow = ( T * R ) * arrow ;
%
if (nOutputs == 2)
    H = patch( arrow(1,:), arrow(2,:), colour,...
    'edgecolor', colour );
else
    patch( arrow(1,:), arrow(2,:), colour,...
    'edgecolor', colour );
end;
%
