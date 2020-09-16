function StateTiming(t0)
%STATETIMING Display timing of Bpod states
%   STATETIMING visualizes the state timings of a Bpod's most recently run
%   trial. It only has one optional parameter, T0, that can be used to
%   shift the x-axis by a user-defined of seconds. This can be useful if
%   you want to display the state timings relative to a specific event
%   (e.g., the onset of a stimulus).

%   Copyright (C) 2020 Florian Rau
% 
%   This program is free software: you can redistribute it and/or modify it
%   under the terms of the GNU General Public License as published by the
%   Free Software Foundation, either version 3 of the License, or (at your
%   option) any later version.
% 
%   This program is distributed in the hope that it will be useful, but
%   WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   General Public License for more details.
% 
%   You should have received a copy of the GNU General Public License along
%   with this program.  If not, see <https://www.gnu.org/licenses/>.


% obtain access to Bpod data, return if empty
global BpodSystem
if isempty(fieldnames(BpodSystem.Data))
    return
end

% obtain axes handle for plots
persistent hAx
if isempty(hAx) || ~isvalid(hAx)
    tmp = figure( ...
        'Name',                 'State Timing', ...
        'NumberTitle',          'off', ...
        'MenuBar',              'none');
    hAx = axes(tmp, ...
        'YDir',                 'reverse', ...
        'XGrid',                'on', ...
        'YGrid',                'on', ...
        'Box',                  'off', ...
        'TickDir',              'out', ...
        'PickableParts',        'none', ...
        'HitTest',              'off', ...
        'TickLabelInterpreter', 'none');
    set(tmp,'HandleVisibility', 'off')
    xlabel(hAx,'Time [s]')
end

% handle user input for shifting the x-axis
if ~exist('t0','var')
    t0  = 0;
end

% some variables
states  = BpodSystem.Data.RawEvents.Trial{end}.States;  % the most recent state timings
names   = fieldnames(states);                           % state names
nStates = numel(names);                                 % number of states
nTrial  = numel(BpodSystem.Data.RawEvents.Trial);       % number of current trial
hBar    = .9;                                           % height of bars
colors  = colororder;                                   % a list of face colors

% plot state timings
cla(hAx)
hold(hAx,'on')
if t0
    xline(hAx,0,':');
end
for idxState = 1:nStates
    x = states.(names{idxState}) - t0;
    x = [x fliplr(x)]';
    y = repmat(idxState + hBar./[2;2;-2;-2],1,size(x,2));
    c = colors(mod(idxState-1,size(colors,1))+1,:);
    patch(hAx,x,y,c)
end

% format axes & labels
set(hAx, ...
    'YTick',        1:nStates, ...
    'YTickLabel', 	names, ...
    'YLim',       	[.5 nStates+.5])
title(hAx,sprintf('State Timing, Trial %d',nTrial))