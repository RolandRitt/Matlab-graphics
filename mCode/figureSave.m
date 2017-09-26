function figureSave(H, fileName, varargin)
%% save figure to disk
%
% Purpose : This function can be used to save the current
%   figure to a pdf graphics file.
%
% Use (syntax):
%   figureSave(H, fileName)
%   figureSave(H, fileName, fileFormat, where)
%
% Input Parameters :
%   H: handel to the figure to be saved
%   fileName: the name of the file to be used
%   fileFormat: '-pdf', '-eps', '-png', '-tiff',
%               '-jpg', '-bmp'};
%   where: location where to save the file defined in
%               relative file paths, e.g., ../figures.
%
% Return Parameters :
%
% Description and algorithms:
%
% References :
%
% Author :  Matthew Harker and Paul O'Leary
% Date :    17. January 2015
% Version : 1.0
%
% (c) 2015 Matthew Harker and Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
%
% History:
%   Date:           Comment:
%

if nargin < 2
    error('You must enter a minimum of a file handle and file name.');
end;
%
if nargin > 4
    error('At most 4 inputs are expected');
end
%% Define default values
%
defWhere = cd;
defFileFormat = '-pdf';
% assign the defaults
argsin = {defFileFormat, defWhere};
% over-write the values with the non-empty input values
nonEmpty = cellfun( @(x) ~isempty(x), varargin);
argsin(nonEmpty) = varargin(nonEmpty);
% Assign names which are easy to remember
[fileFormat, where] = argsin{:};
%% Validate the paramaters
%
if ~isgraphics(H,'figure')
    error('The paramater H must be a handle to a figure');
end;
%
if ~ischar( fileName )
    error('The file name must be a string.');
end;
%
validFormats = {'-pdf', '-eps', '-png', '-tiff',...
    '-jpg', '-bmp'};
validatestring( fileFormat, validFormats, 'saveFile', 'fileFormat');
%
if ~ischar( where )
    error('The where parameter must be a string');
end;

%% Save the figure
%
figure(H);
tempCD = cd;
cd( where );
try
export_fig( fileName, fileFormat,  '-r 600') ;
catch ME
    warning(ME.message);
end
    
cd( tempCD );

