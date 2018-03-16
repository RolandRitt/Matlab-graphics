function [A, ph] = plotMulti( x, D, varargin )
%% PlotMulti: plot multiple signals with a common x ordinate
%
% Purpose : This function plots multiple data sets all with
% the same x ordinate.
%
% Use (syntax):
%   A = plotMulti( x, D, xLabel, yLabels, ratios, offsetScale )
%
% Input Parameters :
%   x: column vector for the common x values
%   D: a matrix of data, each column represents a seperate
%       plot.
%   xLable: (optional)
%   yLabels: (optional) cell array of y-labels
%   ratios: (key-value; optional) a vector of relative sized for the plots.
%   offsetScale: (key-value; optional) set the vertival offset between the plots,
%   unmatched: (key-value; optional) all not specified key-value pairs are
%   passed to the plot function;
%
% Return Parameters :
%   A: a vector of handels to the axes.
%
% Author :  Matthew Harker and Paul O'Leary
% Date :    17. January 2016
% Version : 1.0
%
% (c) 2016 Matthew Harker and Paul O'Leary,
% Chair of Automation, University of Leoben, Leoben, Austria
% email: office@harkeroleary.org,
% url: www.harkeroleary.org
%
% History:
%   Date: 09.06.2017          Comment: delete background axes
%   Date: 04.07.2017          Comment: allow datetime x-axis
%   Date: 05.07.2017          Comment: add possibility to add plot
%   key-value pairs
%   Date: 07.09.2017          Comment: resize axis to fit to the title
%

%% Validate the input paramaters
p = inputParser;
p.KeepUnmatched = true;
if isdatetime(x)
    addRequired(p,'x',@(x) validateattributes(x,{'datetime'}, {'nonempty', 'column'}));
else
    addRequired(p,'x',@(x) validateattributes(x,{'numeric'}, {'real','nonnan','column'}));
end

% addRequired(p,'x',@(x)validateattributes(x,{'numeric', 'datetime'}, {'nonempty','nonnan','column' }));
% addRequired(p,'x',@(x)validateattributes(x,{'numeric'},...
%   {'real','nonnan','column'}));
[xn, xm] = size( x );
%

if ~iscell(D)
    addRequired(p,'D',@(x)validateattributes(x,{'numeric'},...
        {'ndims', 2,'real','nrows',xn}));
else
    for i=D;
        validateattributes(i{1},{'numeric'},...
            {'ndims', 2,'real','nrows',xn});
    end
    addRequired(p,'D');
end

[Dn, Dm] = size( D );
%
addOptional(p,'xLabel',[],@(x)validateattributes(x,{'char'},{'vector'}));
%
addOptional(p,'yLabels',[],@(x)validateattributes(x,{'cell'},{'vector'}));
%
addParameter(p,'ratios',[],@(x)validateattributes(x,{'numeric'},...
    {'real','finite','nonnan','positive', 'column','nrows',Dm}));
%
addParameter(p,'offsetScale',[0.01],@(x)validateattributes(x,{'numeric'},...
    {'real','finite','nonnan', 'scalar'}));
% addParameter(p,'plotParams',{},@iscell);
%
parse(p,x,D,varargin{:});

tmp = [fieldnames(p.Unmatched),struct2cell(p.Unmatched)];
UnmatchedArgs = reshape(tmp',[],1)';
%% setup the frame for all the axes
% Test if an Axis is already open, if yes use it

%h = get( gcf, 'Children');
h = findobj( gcf, 'Type', 'Axes' );
if isempty( h )
    
    
    if ~isempty( p.Results.xLabel ) %if label given, we have to shift
        ax = axes;
        xlabel('dummy');
        aPos = get(ax,'Position');
        delete(ax);
    else
        % if no axes is available then get default position (with label)
        aPos = get(groot, 'defaultAxesPosition');
    end
    
else
    % if axes available then use its position.
    aPos = get( gca, 'Position');
    delete(gca); % 09.06.2017
end
%
x0 = aPos(1);
y0 = aPos(2);
w = aPos(3);
h = aPos(4);
%
offset = p.Results.offsetScale * h ;
%
%% Setup the axes
ha = zeros(Dm,1);
%
if isempty( p.Results.ratios )
    % use equal spacing if non is specified
    ha(:) = h / Dm ;
else
    nr = length(p.Results.ratios);
    ratios = ones( Dm, 1 );
    ratios( 1:nr ) = p.Results.ratios;
    %
    sumR = sum( ratios );
    ha = h * ratios / sumR;
end
%
y0s = y0 + h - cumsum( ha );
%
%% generate the axes
%preallocate
A = gobjects(1, Dm);
ph = gobjects(1, Dm);
for k=1:(Dm)
    A(k) = axes('Position',...
        [x0, y0s(k), w, ha(k) - offset ]);
    %
    if iscell(D)
        ph ={};
        ph{k} =plot(A(k), x, D{:,k}, UnmatchedArgs{:});
    else
        ph(k) =plot(A(k), x, D(:,k), UnmatchedArgs{:});
    end
    %
    
    %% add Y axis label and ticks
    
    
    if mod(k,2) == 0
        set( A(k),'YAxisLocation', 'right');
        %                  posLabel = [1.05, 0.5, 0];
        %         posLabel = [-0.05, 0.5, 0];
        LabelAl = 'top';
    else
        set( A(k),'YAxisLocation', 'left');
        %                  posLabel = [-0.05, 0.5, 0];
        LabelAl = 'bottom';
    end
    
    if ~isempty(p.Results.yLabels)
        name = strrep(p.Results.yLabels{k},'_','-');
        ylabel( name, 'Rotation', 90, ...
            'VerticalAlignment', LabelAl,...
            'HorizontalAlignment', 'center');
    end
    
    grid on;
    %
    axis tight;
    % Here I need to take care of rescaling the positions
    % of the yTicklabels
end

% clear x-Ticks
for k=1:(Dm-1)
    set(A(k),'XTickLabel', []);
end

%% to adopt axes to be in the figure
title(A(1), 'Dummy');

outPosleft = zeros(Dm,1);
outPosright = zeros(Dm,1);
for k = 1:Dm %correct y label to be in figure
    ax = A(k);
    
    outerpos = ax.OuterPosition;
    outerpos(1) = 0;
    outerpos(3) = 1;
    ax.OuterPosition = outerpos;
    
    ti = ax.TightInset;
    ax.Position(1) = ti(1);
    ax.Position(3) = 1- (ti(1)+ti(3));
    outPosleft(k) = ax.Position(1);
    outPosright(k) = (ax.Position(1) + ax.Position(3));
    % from Matlab: https://de.mathworks.com/help/matlab/creating_plots/save-figure-with-minimal-white-space.html
    % description wrong = TigthInset is from Outer Position to labels
    % ax = gca;
    % outerpos = ax.OuterPosition;
    % ti = ax.TightInset;
    % left = outerpos(1) + ti(1);
    % bottom = outerpos(2) + ti(2);
    % ax_width = outerpos(3) - ti(1) - ti(3);
    % ax_height = outerpos(4) - ti(2) - ti(4);
    % ax.Position = [left bottom ax_width ax_height];
end
outPosleftMax = max(outPosleft);
outPosrightMin = min(outPosright);

% outPosleftMax = min(outPosleft);
% outPosrightMin = max(outPosright);


%% resize heigths of axes

A(1).OuterPosition(2) = 0;
A(1).OuterPosition(4) = 1;
A(end).OuterPosition(2) = 0;

tiLow = A(end).TightInset(2);
tiHigh = 1 - A(1).TightInset(4);

h = tiHigh - tiLow;
offset = p.Results.offsetScale * h ;
%
%% Setup the axes
ha = zeros(Dm,1);
%
if isempty( p.Results.ratios )
    % use equal spacing if non is specified
    ha(:) = h / Dm ;
else
    nr = length(p.Results.ratios);
    ratios = ones( Dm, 1 );
    ratios( 1:nr ) = p.Results.ratios;
    %
    sumR = sum( ratios );
    ha = h * ratios / sumR;
end
%
y0s = tiLow + h - cumsum( ha );


for k = 1:Dm %correct y label to be in figure
    
    %
    A(k).Position(2) = y0s(k);
    A(k).Position(4) = ha(k) - offset;
    
end
yLabelPoseven = zeros(round(Dm/2),3);
yLabelPosodd = zeros(floor(Dm/2),3);
for k = 1:Dm %correct Title label to be in figure
    %
    A(k).Position(1) = outPosleftMax;
    A(k).Position(3) = outPosrightMin - outPosleftMax;
    %     set(A(k), 'ActivePositionProperty', 'OuterPosition');
    
    
    
    if mod(k,2) == 0
        yLTemp = get( A(k),'yLabel');
        set(yLTemp, 'Units', 'normalized');
        yLabelPoseven(k/2,:) = get(yLTemp, 'Pos');
    else
        yLTemp = get( A(k),'yLabel');
        %                  posLabel = [1.05, 0.5, 0];
        %         posLabel = [-0.05, 0.5, 0];
        set(yLTemp, 'Units', 'normalized')
        yLabelPosodd(round(k/2),:) = get(yLTemp, 'Pos');
    end
end

maxYLabel = min(yLabelPosodd(:,1));
minYLabel = max(yLabelPoseven(:,1));
yLabelPosodd(:,1) = maxYLabel;
yLabelPoseven(:,1) = minYLabel;

%% I you d'like to align the yLabels
% for k = 1:Dm %correct Title label to be in figure
%      if mod(k,2) == 0
%         yLTemp = get( A(k),'yLabel');
%        set(yLTemp, 'Pos', yLabelPoseven(k/2,:));
%     else
%         yLTemp = get( A(k),'yLabel');
%        set(yLTemp, 'Pos', yLabelPosodd(round(k/2),:));
%     end
% end

%% annotate the x axis;
if ~isempty( p.Results.xLabel )
    axes( A(Dm) );
    xlabel( p.Results.xLabel );
end
%
title(A(1), '');
linkaxes( A, 'x');
set(zoom(gcf),'Motion','horizontal','Enable','on');








