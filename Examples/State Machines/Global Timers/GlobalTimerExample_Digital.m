% Example state matrix: A global timer ends an infinite loop. It is
% triggered in the first state, but begins measuring its 3-second Duration 
% after a 1.5s onset delay. When the timer begins measuring, it sets BNC output channel 2
% high. When the timer's 3 second duration elapses, BNC output channel 2 is returned low, 
% and a GlobalTimer1_End event occurs (handled in both cases by exiting the state machine).

sma = NewStateMachine;
sma = SetGlobalTimer(sma, 'TimerID', 1, 'Duration', 3, 'OnsetDelay', 1.5, 'Channel', 'BNC2', 'OnLevel', 1, 'OffLevel', 0); 
sma = AddState(sma, 'Name', 'TimerTrig', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'Port1Lit'},...
    'OutputActions', {'GlobalTimerTrig', 1});
sma = AddState(sma, 'Name', 'Port1Lit', ...
    'Timer', .25,...
    'StateChangeConditions', {'Tup', 'Port3Lit', 'GlobalTimer1_End', '>exit'},...
    'OutputActions', {'PWM1', 255});
sma = AddState(sma, 'Name', 'Port3Lit', ...
    'Timer', .25,...
    'StateChangeConditions', {'Tup', 'Port1Lit', 'GlobalTimer1_End', '>exit'},...
    'OutputActions', {'PWM3', 255});

