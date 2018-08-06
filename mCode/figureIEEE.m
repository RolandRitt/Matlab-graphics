function H = figureGen( varargin )
% figureGen: generate a figure with my desired properties.
% The default is suitable for the Springer definitions. 
%
% Purpose : This function generate a figure with the 
% desired size and sets the desired defult fonts. All 
% properties are set so that saving the figure to disk with
% generate the desired figure with the correct bounding box.
%
% Use (syntax):
%   H = figureGen( height, width, fontSize, font ); 
%
% Input Parameters :
%   height, width : the height and width of the figure in 
%                   cm. The default is
%                   width = 11.7, height = 8.8;
%   fontSize: default = 10;
%   font: default 'Times'
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
if nargin > 4     
   error('figureGen: at most 4 inputs are expected');
end
%
% Define default values
%
defWidth = 8.3;
defHeight = 6;
defFontSize = 9;
defFont = 'Times';
%
% assign the defaults
%
argsin = {defHeight, defWidth, defFontSize, defFont};
%
% over-write the values with the non-empty input values
%
nonEmpty = cellfun( @(x) ~isempty(x), varargin);
argsin(nonEmpty) = varargin(nonEmpty);
%
% Assign names which are easy to remember
%
[height, width, fontSize, font] = argsin{:};
%% validate the input paramaters
%
% This code verifies if the input parameters have the
% correct atributes
%
whAttributes = {'positive','finite','scalar','real'};
validateattributes(width,{'double'},whAttributes,...
    'figureMy2','width');
validateattributes(height,{'double'},whAttributes,...
    'figureMy2','height');
fontSizeAttributes = {'positive','finite','scalar',...
    'real','integer'};
validateattributes(fontSize,{'double'},fontSizeAttributes,...
    'figureMy2','fontSize');
% Now we test if the named font is vavailable on the
% computer
if ~strcmp( font , defFont )
    if ~any( strcmp( font, listfonts ))
        error('Invalid font: see the command listfonts'); 
    end;
end;
%% Generate a figure with the desired properties
%
figureSize = [1 1 width height];
%
H = figure( 'Color', [1,1,1],...
        'Units','centimeters',...
        'Position',figureSize,...
        'PaperUnits','centimeters',...
        'PaperPosition',[0 0 width height],...
        'PaperSize',[width height],...
        'Renderer','painters',...
        'PaperType','A4');
%
% Set defaults for axes.
set(H,'DefaultAxesFontName',font);
set(H,'DefaultAxesFontSize',fontSize);
set(H,'DefaultAxesLabelFontSizeMultiplier',1);
set(H,'DefaultAxesTicklabelInterpreter', 'latex');
set(H,'DefaultAxesTitleFontWeight', 'normal');
% set text defaults
set(H,'DefaultTextFontName',font);
set(H,'DefaultTextFontSize',fontSize);
set(H,'DefaultTextInterpreter', 'latex');

