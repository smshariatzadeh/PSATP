function fig = fm_eigfig()
% FM_EIGFIG create GUI for eigenvalue (small signal stability) analysis
%
% HDL = FM_EIGFIG()
%
%see also FM_EIGEN
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Version:   1.0.0
%
%E-mail:    federico.milano@ucd.ie
%Web-site:  faraday1.ucd.ie/psat.html
%
% Copyright (C) 2002-2019 Federico Milano

global DAE SSSA Bus Settings Theme Fig File

if ishandle(Fig.eigen), figure(Fig.eigen), return, end

if strcmp(Settings.platform,'MAC')
  dm = 0.005;
  aligntxt = 'center';
else
  dm = 0;
  aligntxt = 'left';
end

SSSA.neig = 1;
metodi = {'All';'Largest Magnitude';'Smallest Magnitude'; ...
	  'Largest Real Part';'Smallest Real Part'; ...
	  'Largest Imag Part';'Smallest Imag Part';};

h0 = figure('Color',Theme.color01, ...
	    'Units', 'normalized', ...
	    'Colormap', [], ...
	    'CreateFcn','Fig.eigen = gcf;', ...
	    'DeleteFcn','Fig.eigen = -1;', ...
	    'FileName','fm_eigfig', ...
            'MenuBar','none', ...
	    'DoubleBuffer', 'on', ...
	    'Name','Eigenvalue Analysis', ...
	    'NumberTitle','off', ...
	    'PaperPosition',[18 180 576 432], ...
	    'PaperUnits','points', ...
	    'Position',sizefig(0.6523,0.6201), ...
	    'ToolBar','none');

if Settings.hostver < 7.05
  set(h0,'ShareColors','on')
end

if Settings.hostver <= 7.09
  set(h0,'MinColormap', 300)
end

fm_set colormap

% Menus
% Menu File
h1 = uimenu('Parent',h0, ...
            'Label','File', ...
            'Tag','MenuFile');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_eigen runsssa', ...
            'Label','Run', ...
            'Tag','OTV', ...
            'Accelerator','z');
h2 = uimenu('Parent',h1, ...
            'Callback','close(gcf)', ...
            'Label','Exit', ...
            'Tag','NetSett', ...
            'Accelerator','x', ...
            'Separator','on');

% Menu View
h1 = uimenu('Parent',h0, ...
            'Label','View', ...
            'Tag','MenuView');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_eigen report', ...
            'Label','Write report', ...
            'Tag','OTW', ...
            'Accelerator','w');
h2 = uimenu('Parent',h1, ...
            'Callback','figure, axes, fm_eigen graph', ...
            'Label','Export Graph', ...
            'Tag','OTV', ...
            'Accelerator','e');
h2 = uimenu('Parent',h1, ...
            'Callback','fm_tviewer', ...
            'Label','Select text viewer', ...
            'Tag','NetSett', ...
            'Accelerator','t', ...
            'Separator','on');


h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color03, ...
	       'FontName',Theme.font01, ...
	       'ForegroundColor',Theme.color06, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.55689      0.6378     0.38563     0.28031], ...
	       'String',' ', ...
	       'Style','listbox', ...
	       'Tag','Listbox1', ...
	       'Value',1);
h1 = axes('Parent',h0, ...
	  'Box','on', ...
	  'CameraUpVector',[0 1 0], ...
	  'CameraUpVectorMode','manual', ...
	  'Color',Theme.color11, ...
	  'ColorOrder',Settings.color, ...
	  'Position',[0.0922 0.3528 0.4323 0.5654], ...
	  'Tag','Axes1', ...
	  'XColor',[0 0 0], ...
	  'YColor',[0 0 0], ...
	  'ZColor',[0 0 0]);
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.55569    0.064567     0.38563     0.21417], ...
	       'Style','frame', ...
	       'Tag','Frame1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color03, ...
	       'Callback','fm_eigen runsssa', ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color09, ...
	       'Position',[0.60479     0.1-dm    0.069+dm    0.06+3*dm], ...
	       'String','Plot', ...
	       'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.55689     0.31811     0.38563     0.27717], ...
	       'Style','frame', ...
	       'Tag','Frame2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.59521     0.45512     0.22994    0.031496], ...
	       'String','Posistive eigs:', ...
	       'Style','text', ...
	       'Tag','StaticText1');

% Frame
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.36287 0.064567 0.16168 0.21417], ...
	       'Style','frame', ...
	       'Tag','Frame3');

% Checkboxes
hmat(1) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_jlfd'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen matrix', ...
	       'Position',[0.4437 0.064567  0.0808   0.1071], ...
	       'TooltipString','Jlfdr Matrix', ...
	       'Style','togglebutton', ...
	       'Tag','Checkbox1');
hmat(2) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_jlfv'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen matrix', ...
	       'Position',[0.36287 0.064567   0.0808  0.1071], ...
	       'TooltipString','Jlfvr Matrix', ...
	       'Style','togglebutton', ...
	       'Tag','Checkbox2');
hmat(3) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_jlfr'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen matrix', ...
	       'Position',[0.4437  0.1717  0.0808   0.1071], ...
	       'TooltipString','Jlfr Matrix', ...
	       'Style','togglebutton', ...
	       'Tag','Checkbox3');
hmat(4) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_state'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen matrix', ...
	       'Position',[0.36287 0.1717  0.0808  0.1071], ...
	       'TooltipString','State Matrix', ...
	       'Style','togglebutton', ...
	       'Tag','Checkbox4', ...
	       'Value',1);

vals = [0, 0, 0, 0];
vals(SSSA.matrix) = 1;
for hh = 1:4; set(hmat(hh),'Value',vals(hh)), end

h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.59521     0.49291     0.17126    0.031496], ...
	       'String','Buses', ...
	       'Style','text', ...
	       'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.59521     0.52913     0.21317    0.031496], ...
	       'String','Dynamic order:', ...
	       'Style','text', ...
	       'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.59521      0.4189     0.23353    0.031496], ...
	       'String','Negative eigs:', ...
	       'Style','text', ...
	       'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.59521     0.34488     0.20599    0.031496], ...
	       'String','Zero eigs:', ...
	       'Style','text', ...
	       'Tag','StaticText1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.59521      0.3811     0.23114    0.031496], ...
	       'String','Complex pairs:', ...
	       'Style','text', ...
	       'Tag','StaticText1');

% Frame
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color03, ...
	       'Position',[0.087425    0.064567     0.27     0.21417], ...
	       'Style','frame', ...
	       'Tag','Frame4');

% Radio Buttons
hmap(1) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_smap'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen map', ...
	       'Position',[0.087425+0.015  0.1  0.0808  0.1071], ...
	       'TooltipString','S-Domain Map', ...
	       'Style','togglebutton', ...
	       'Tag','Radiobutton1', ...
	       'Value',1);
hmap(2) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_pfmap'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen map', ...
	       'Position',[0.2490+0.015 0.1  0.0808  0.1071], ...
	       'TooltipString', 'PF Map', ...
	       'Style','togglebutton', ...
	       'Tag','Radiobutton2');
hmap(3) = uicontrol('Parent',h0, ...
               'CData',fm_mat('eig_zmap'), ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen map', ...
	       'Position',[0.1682+0.015  0.1  0.0808  0.1071], ...
	       'TooltipString','Z-Domain Map', ...
	       'Style','togglebutton', ...
	       'Tag','Radiobutton3');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'ForegroundColor',Theme.color05, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.087425+0.015  0.22   0.23114   0.031496], ...
	       'String','Plot style:', ...
	       'Style','text', ...
	       'Tag','StaticText1');

vals = [0, 0, 0];
vals(SSSA.map) = 1;
for hh = 1:3, set(hmap(hh),'Value',vals(hh)), end

% Push Buttons
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','fm_eigen report', ...
	       'Position',[0.60479+2*0.069+2*0.0072     0.1-dm    0.069+dm    0.06+3*dm], ...
	       'String','Report', ...
	       'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','close(gcf);', ...
	       'Position',[0.60479+3*0.069+3*0.0072     0.1-dm    0.069+dm    0.06+3*dm], ...
	       'String','Close', ...
	       'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color03, ...
	       'Callback','figure, axes, fm_eigen graph', ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color09, ...
	       'Position',[0.60479+0.069+0.0072     0.1-dm    0.069+dm    0.06+3*dm], ...
	       'String','Graph', ...
	       'Tag','Pushbutton1');

h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',[0.502 0.251 0.251], ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.84311     0.52913    0.075449    0.031496], ...
	       'Style','text', ...
	       'String',num2str(DAE.n), ...
	       'Tag','Text1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',[0.502 0.251 0.251], ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.84311     0.49291    0.075449    0.031496], ...
	       'String',num2str(Bus.n), ...
	       'Style','text', ...
	       'Tag','Text2');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',[0.502 0.251 0.251], ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.84311     0.45512    0.075449    0.031496], ...
	       'Style','text', ...
	       'Tag','Text3');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',[0.502 0.251 0.251], ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.84311      0.4189    0.075449    0.031496], ...
	       'Style','text', ...
	       'Tag','Text4');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',[0.502 0.251 0.251], ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.84311      0.3811    0.075449    0.031496], ...
	       'Style','text', ...
	       'Tag','Text5');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'FontWeight','bold', ...
	       'ForegroundColor',[0.502 0.251 0.251], ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.84311     0.34488    0.075449    0.031496], ...
	       'Style','text', ...
	       'Tag','Text6');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color04, ...
	       'Callback','fm_eigen method', ...
	       'ForegroundColor',Theme.color05, ...
	       'Position',[0.60479  0.2  0.190  0.0375], ...
	       'String',metodi, ...
	       'Style','popupmenu', ...
	       'Tag','PopupMenu2', ...
	       'Value',SSSA.method);
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color04, ...
	       'Callback','fm_eigen neig', ...
	       'ForegroundColor',Theme.color05, ...
	       'FontName',Theme.font01, ...
	       'Enable','off', ...
	       'HorizontalAlignment',aligntxt, ...
	       'Position',[0.842    0.2   0.062   0.0375+dm], ...
	       'String',num2str(round(SSSA.neig)), ...
	       'Style','edit', ...
	       'Tag','EditText1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'HorizontalAlignment','left', ...
	       'Position',[0.8225     0.2     0.02    0.0325], ...
	       'String','#', ...
	       'Style','text', ...
	       'Tag','StaticText1');
if nargout > 0, fig = h0; end
