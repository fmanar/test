function PrintPlot(fig, path, varargin)
% PrintPlot(fig, path, ...options...)
% Saves figure to a file.  Defaults to a shrink wrapped 6.5x2.25in pdf so
% it should fit nicely across the page of a Latex doc with correctly sized 
% (9pt) fonts.
%
% v1.0
% by Field Manar
% 
% Options: (order is not important)
%   [sizex, sizey]          -output dimensions in inches
%                               default 6.5x2.25
%                               recognized by 2 num array
%   type                    -output type (see help of 'Print')
%                               default pdf
%                               recognized by string beginning with '-d'
%   'FontSize', fontSize    -font size of output, default 9pt (matches
%                               Latex)
%   'FontName', fontName    -font name, default 'Times'
%   'Silent'                -no printouts
%
% Example:
% >>PrintPlot(gcf, './plot', [3, 2.25], '-dpng', 'FontSize', 12);
% Will save the current figure as a 3x2.25in png with 12pt font named
% 'plot.pdf' in the current folder
%
% Types:
% PDF ('-dpdf') is the default to match latex.
% PNG ('-png') is probably the best raster image format.
% EMF ('-dmeta') is the Powerpoint recognized vectore format.
%
% Note: Raster formats are set to 300dpi i.e. a 1x1 in pic will be
% 300x300 pixels

% Process options
sizex = 6.5;
sizey = 2.25;
type = '-dpdf';
fontSize = 9;
fontName = 'Times';

flagSilent = 0;

if nargin > 2
    argc = 1;
    while argc <= nargin - 2
        argin = varargin{argc};
        if isnumeric(argin) && ...
                isequal(size(argin), [2,1]) || isequal(size(argin), [1,2])
            sizex = argin(1);
            sizey = argin(2);
        elseif ischar(argin) && ...
                strncmp(argin, '-d',2)
            type = argin;
        elseif ischar(argin) && ...
            strcmp(argin, 'Silent')
            flagSilent = 1;
        elseif ischar(argin) &&  argc <= nargin - 3
            switch upper( varargin{argc} )
                case 'FONTSIZE'
                    fontSize = varargin{argc+1};
                    argc = argc + 1;
                case 'FONTNAME'
                    fontName = varargin{argc+1};
                    argc = argc + 1;
                otherwise
                     fprintf('PrintPlot: argument %u, ''%s'' not recognized.\n', ...
                         argc+2, argin);
            end
        else
            fprintf('PrintPlot: argument %u, ''%s'' not recognized or un-paired.\n', ...
                argc+2, argin);
        end
        argc = argc + 1;
    end
end

if ~flagSilent
    fprintf('PrintPlot:\n\tFile: %s\n', path);
    
    fprintf('\tSize: %.2f x %.2f in.\n', sizex, sizey);
    fprintf('\tType: %s\n', type);   
    fprintf('\tFontSize: %.1f pt.\n', fontSize);
    fprintf('\tFontName: %s\n', fontName);
end

set(findall(fig,'type','text'), 'fontSize', fontSize, 'fontName', 'Times');
ax = findall(fig,'type','axes');
set(ax, 'fontSize', fontSize, 'fontName', fontName);

set(fig, 'PaperUnits', 'inches');
set(fig, 'PaperSize', [sizex sizey]);
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 sizex sizey]);

if strcmp(type, '-dpng') || ...
        strcmp(type, '-djpeg') || ...
        strcmp(type, '-dtiff')       
    print(fig, type, '-r300', path);
else
    print(fig, type, path);
end

if ~flagSilent
    fprintf('\tSuccess!\n');
end
end