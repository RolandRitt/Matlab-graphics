function H = figureImage( imageIn, varargin  )
%% Create figure for image
%
% Purpose : This function generates a figure for an image.
% It ensures that the aspectr ration is maintained and that
% there is no white space surrounging the image.
%
% Use (syntax):
%   H = figureImage( imageIn, width, map );
%
% Input Parameters :
%   imageIn: the image to be displayed
%   width: width of the image (optional, default = 11cm)
%   map: the colormap to be used (optional).
%
% Return Parameters :
%   H: a handel to the figure.
%
% Description and algorithms:
%
% References : 
%
% Author :  Matthew Harker and Paul O'Leary
% Date :    7. Sept 2015
% Version : 1.0
%
% (c) 2015 Matthew Harker and Paul O'Leary, 
% Chair of Automation, University of Leoben, 
% Leoben, Austria
% email: office@harkeroleary.org, 
% url: www.harkeroleary.org
%
% History:
%   Date:           Comment:
%

%% Check the input paramater number and assign defaults
% is the correct number of inputs given
if nargin < 1
    error('No inpute provided');
end;
%
if nargin > 3     
   error('At most 3 inputs are expected');
end
%% Define default values
%
defWidth = 11.7;
defMap = [];
% assign the defaults
argsin = {defWidth, defMap};
% over-write the values with the non-empty input values
nonEmpty = cellfun( @(x) ~isempty(x), varargin);
argsin(nonEmpty) = varargin(nonEmpty);
%
% Assign names which are easy to remember
%
[width, map] = argsin{:};
%% Validate the inputs
validateattributes(imageIn,{'numeric'},{'nonempty'});
%
whAttributes = {'positive','finite','scalar','real'};
validateattributes(width,{'double'},whAttributes,...
    'figureImage','width');
%
%% Compute the required height
%
[n,m,~] = size( imageIn );
aspectRatio = n / m ;
height = width * aspectRatio;
%
H = figureGen( height, width );
%
%% generate the image 
%
axisPosition=[0 0 1 1];
A = axes( 'position', axisPosition );
I = imagesc( imageIn );
axis image;
%
if isempty( map )
    map = colormap;
end;
validateattributes(map,{'numeric'},{'nonempty',...
    '2d','ncols', 3});

colormap(map);
axis image;
axis off;
hold on;