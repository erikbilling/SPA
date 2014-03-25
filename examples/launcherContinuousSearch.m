
% Search example over a 2D surface, using four elementary behaviors (north,
% east, south, and west). The four EBs are connected in a pattern that
% corresponds to a map. A stimulation at a specific goal position in the
% motivation fields will create a dijkstra-like search for the
% starting point (indicated by inhibitions in the precondition fields).
% When the starting point is reached, the shortest path is chased back
% towards the goal. 

%% setting up the simulator

% shared parameters
fieldSize = 100;
sigma_exc = 2;

% create simulator object
sim = Simulator();

% create inputs (and sum for visualization)
sim.addElement(GaussPosition2D('goal', [fieldSize fieldSize], sigma_exc, sigma_exc, 12, 75, 25, true, false));
sim.addElement(GaussStimulus2D('stimulus 2', [fieldSize fieldSize], sigma_exc, sigma_exc, 0, 25, 75, true, false));
sim.addElement(GaussStimulus2D('cstate', [fieldSize fieldSize], sigma_exc, sigma_exc, -15, 75, 75, true, false));

% Current state stimulus
sim.addElement(Cursor('cursor',[fieldSize fieldSize],[55 65],-20));
sim.addElement(JoinInputs('goal-coord',2),{'goal','goal'},{'positionY','positionX'});
sim.addElement(NeuralField('go',[fieldSize fieldSize],2,-5,4));

% Create map

map = EBMap('map',zeros(fieldSize, fieldSize),[5 5]);
map.matrix(40:50,50:60) = 1;
map.matrix(50:80,30:40) = 1;

sim.addElement(map,{'cursor','goal-coord'},{'pos','output'});
sim.addElement(GaussKernel2D('map-output',[fieldSize fieldSize], 2, 2, 15),'map');


% Create elementary behaviors
cellSize = 5;
lateralConnectionShift = cellSize;
interConnectionShift = cellSize*2;
ic = 7;
inputs = {'motivation',{'goal','stimulus 2','map-output'},'precondition','cursor'};
north = EBMove(sim,'north',[fieldSize fieldSize], 5, -5, 4, sigma_exc, inputs, ...
    {'motivation','precondition',{'shift',[cellSize 0]},'precondition','intention',{'shift',[-cellSize 0]}, 'intention','cos',ic});
north.createLateralConnections([lateralConnectionShift 0]);

south = EBMove(sim,'south',[fieldSize fieldSize], 5, -5, 4, sigma_exc, inputs, ...
    {'motivation','precondition',{'shift',[-cellSize 0]},'precondition','intention',{'shift',[cellSize 0]}, 'intention','cos',ic});
south.createLateralConnections([-lateralConnectionShift 0]);

west = EBMove(sim,'west',[fieldSize fieldSize], 5, -5, 4, sigma_exc, inputs, ...
    {'motivation','precondition',{'shift',[0 cellSize]},'precondition','intention',{'shift',[0 -cellSize]}, 'intention','cos',ic});
west.createLateralConnections([0 lateralConnectionShift]);

east = EBMove(sim,'east',[fieldSize fieldSize], 5, -5, 4, sigma_exc, inputs, ...
    {'motivation','precondition',{'shift',[0 -cellSize]},'precondition','intention',{'shift',[0 cellSize]}, 'intention','cos',ic});
east.createLateralConnections([0 -lateralConnectionShift]);


north.createInterConnections(west);
north.createInterConnections(east);
north.createBlockingConnections(south,[interConnectionShift 0]);
south.createInterConnections(west);
south.createInterConnections(east);
south.createBlockingConnections(north,[-interConnectionShift 0]);
west.createInterConnections(north);
west.createInterConnections(south);
west.createBlockingConnections(east,[0 interConnectionShift]);
east.createInterConnections(north);
east.createInterConnections(south);
east.createBlockingConnections(west,[0 -interConnectionShift]);

sim.addElement(SumInputs('go-stimulus',[fieldSize fieldSize]),{'north.intention','east.intention','south.intention','west.intention'}, {'output', 'output', 'output', 'output'});
sim.addElement(GaussKernel2D('go-input', [fieldSize fieldSize], 2, 2, 8), 'go-stimulus','output', 'go');
sim.addElement(GaussKernel2D('go-exec', [fieldSize fieldSize], 2, 2, 15), 'go','output','go');
sim.addElement(SumDimension('go-sum', [1 2], 1, -0.2),'go','output','go');
sim.addElement(PeakPosition('go.target'),'go','output','cursor');

% sim.addElement(PeakPosition('target'),{'north.cos','east.cos','south.cos','west.cos'},{'output','output','output','output'},'cursor');

video = VideoRecorder('ebContinousSearch',1,[0 200 936 576]);
sim.addElement(video);

%% setting up the GUI

gui = StandardGUI(sim, [50, 50, 943, 780], 0.05, [0.0, 1/4, 1.0, 3/4], [2, 3], 0.06, [0.0, 0.0, 1.0, 1/4], [7, 4]);
activationScale = [-10 10];

gui.addVisualization(EBPlot2d(north),[1, 1]);
gui.addVisualization(EBPlot2d(south),[2, 1]);
gui.addVisualization(EBPlot2d(west),[1, 2]);
gui.addVisualization(EBPlot2d(east),[2, 2]);

gui.addVisualization(ScaledImage('go','activation',[-10 10],{},{},'Action'),[1, 3]);
gui.addVisualization(ScaledImage('map','display',[0 5],{},{},'Map'),[2, 3]);


% add sliders
% resting level and noise
% gui.addControl(ParameterSlider('h_p', 'eb1.precondition', 'h', [-10, 0], '%0.1f', 1, 'resting level of precondition field'), [1, 1]);
% gui.addControl(ParameterSlider('noise', 'eb1.precondition.noise.kernel', 'amplitude', [0, 10], '%0.1f', 1, ...
%   'noise level for precondition field'), [2, 1]);
gui.addControl(TextLabel('Use s1_c to give a goal input'),[4,1]);
gui.addControl(TimeLabel('Time: %d'),[4,2]);
gui.addControl(ParameterSlider('s1_x', 'goal', 'positionX', [0, fieldSize], '%0.1f', 1, 'width of stimulus 1'), [5, 1]);
gui.addControl(ParameterSlider('s1_y', 'goal', 'positionY', [0, fieldSize], '%0.1f', 1, ...
  'position of stimulus 1'), [5, 2]);
gui.addControl(ParameterSlider('s1_c', 'goal', 'amplitude', [0, 20], '%0.1f', 1, ...
  'stength of stimulus 1'), [5, 3]);
gui.addControl(ParameterSlider('goal_x', 'stimulus 2', 'positionX', [0, fieldSize], '%0.1f', 1, 'width of stimulus 2'), [6, 1]);
gui.addControl(ParameterSlider('goal_y', 'stimulus 2', 'positionY', [0, fieldSize], '%0.1f', 1, ...
  'position of stimulus 2'), [6, 2]);
gui.addControl(ParameterSlider('goal_c', 'stimulus 2', 'amplitude', [0, 20], '%0.1f', 1, ...
  'stength of stimulus 2'), [6, 3]);
gui.addControl(ParameterSlider('s3_x', 'cstate', 'positionX', [0, fieldSize], '%0.1f', 1, 'x position of stimulus 3'), [7, 1]);
gui.addControl(ParameterSlider('s3_y', 'cstate', 'positionY', [0, fieldSize], '%0.1f', 1, ...
  'position of stimulus 3'), [7, 2]);
gui.addControl(ParameterSlider('s3_c', 'cstate', 'amplitude', [0, 20], '%0.1f', -1, ...
  'stength of stimulus 3'), [7, 3]);

% add buttons
gui.addControl(GlobalControlButton('Pause', gui, 'pauseSimulation', true, false, false, 'pause simulation'), [1, 4]);
gui.addControl(GlobalControlButton('Reset', gui, 'resetSimulation', true, false, true, 'reset simulation'), [2, 4]);
gui.addControl(GlobalControlButton('Parameters', gui, 'paramPanelRequest', true, false, false, 'open parameter panel'), [3, 4]);
gui.addControl(GlobalControlButton('Record', video, 'record', true, false, false, 'Recod video'), [4, 4]);
gui.addControl(GlobalControlButton('Quit', gui, 'quitSimulation', true, false, false, 'quit simulation'), [6, 4]);


%% run the simulator in the GUI

gui.run(inf);


