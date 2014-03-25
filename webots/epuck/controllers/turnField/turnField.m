% Description: MATLAB controller for Webots
% File:        turnField.m
% Author:      Erik Billing 

% Uncomment the next two lines if you want to use
% MATLAB's desktop and interact with the controller
%desktop;
%keyboard;

setpath
% Alternatively, specify a custom Cosivina path:
% setpath /My/Cosivina/Dir

% Initiate a random seed, comment out to fix the seed. 
rng('shuffle');

%% Global parameters
% The size of the field (must match Webots simulation)
fieldSize = 100; 
% fieldSize = 210;
fsize = [fieldSize fieldSize];

% Size of angular fields
angsize = 100;  

% Default field sigma
sigma_exc = 2;

% Record field activity
global recordActivation noiseLevel;
% recordActivation = 1:1400;
recordVideo = false;

% The noise level depends on the run set configuration. See documentation
% for details. 
initNoiseLevel;

%% Setting up the simulator

% create simulator object
sim = Simulator();

% create inputs (and sum for visualization)
sim.addElement(GaussPosition2D('stimulus 1', fsize, 3, 3, 10, 0, 0, true, false));
sim.addElement(GaussStimulus2D('stimulus 2', fsize, sigma_exc, sigma_exc, 0, round(1/2*fieldSize), round(1/4*fieldSize), true, false));
sim.addElement(GaussStimulus2D('stimulus 3', fsize, sigma_exc, sigma_exc, -5, round(1/4*fieldSize), round(1/4*fieldSize), true, false));
sim.addElement(JoinInputs('goal-coord',2),{'stimulus 1','stimulus 1'},{'positionY','positionX'});

% create E-Puck controller
epuck = EPuckController('epuck',fsize,angsize);
sim.addElement(epuck,{},{},'stimulus 1','goal');
sim.addElement(ScaleInput('epuck-exec',fsize,8),'epuck');

% init map
map = setupMap(fsize,[5 5],noiseLevel);

sim.addElement(map,{'epuck','epuck','goal-coord'},{'position','obstacles','output'});
sim.addElement(GaussKernel2D('map-output',fsize, 2, 2, 15),'map');

% Create elementary behaviors
cellSize = 5;
interConnectionShift = cellSize;

north = setupMove(sim,'north',fsize,[cellSize 0]);
south = setupMove(sim,'south',fsize,[-cellSize 0]);
west = setupMove(sim,'west',fsize,[0 cellSize]);
east = setupMove(sim,'east',fsize,[0 -cellSize]);

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

sim.addElement(NeuralField('ps', angsize, 5, -5, 3),'epuck','psField');
sim.addElement(GaussKernel1D('ps-inhib',angsize,12,-16),'ps');
sim.addElement(SumDimension('ps-exec',2,1,0.01),'ps');
createTurnField(sim, angsize, 'north', pi/2', 'epuck','ps-inhib');
createTurnField(sim, angsize, 'east', 0, 'epuck','ps-inhib');
createTurnField(sim, angsize, 'west', pi, 'epuck','ps-inhib');
createTurnField(sim, angsize, 'south', pi*3/2, 'epuck','ps-inhib');
sim.addElement(NeuralField('go',fsize,2,-5,4));

video = VideoRecorder('EPuckController',1,[0 200 1380 576],recordVideo);
sim.addElement(video);


%% Setting up the GUI

gui = StandardGUI(sim, [50, 50, 1380, 780], 0.05, [0.0, 1/4, 1.0, 3/4], [2, 5], 0.06, [0.0, 0.0, 1.0, 1/4], [7, 4]);

gui.addVisualization(EBPlot2d(north),[1, 1]);
gui.addVisualization(EBPlot2d(south),[2, 1]);
gui.addVisualization(EBPlot2d(west),[1, 2]);
gui.addVisualization(EBPlot2d(east),[2, 2]);
gui.addVisualization(ScaledImage('map','output',[-1 4],{},{},'Map'),[1, 5]);
gui.addVisualization(MultiPlot({'north.turn', 'north.turn'}, {'activation', 'output'}, ...
  [1, 10], 'horizontal', {'YLim', [-15, 15], 'XGrid', 'on', 'YGrid', 'on'}, ...
  {{'b', 'LineWidth', 3}, {'r', 'LineWidth', 2}, {'Color', [0, 0.75, 0], 'LineWidth', 2}}, ...
  'North Turn', 'feature space', 'activation/input/output'), [1, 3]);
gui.addVisualization(MultiPlot({'south.turn', 'south.turn'}, {'activation', 'output'}, ...
  [1, 10], 'horizontal', {'YLim', [-15, 15], 'XGrid', 'on', 'YGrid', 'on'}, ...
  {{'b', 'LineWidth', 3}, {'r', 'LineWidth', 2}, {'Color', [0, 0.75, 0], 'LineWidth', 2}}, ...
  'South Turn', 'feature space', 'activation/input/output'), [2, 3]);
gui.addVisualization(MultiPlot({'west.turn', 'west.turn'}, {'activation', 'output'}, ...
  [1, 10], 'horizontal', {'YLim', [-15, 15], 'XGrid', 'on', 'YGrid', 'on'}, ...
  {{'b', 'LineWidth', 3}, {'r', 'LineWidth', 2}, {'Color', [0, 0.75, 0], 'LineWidth', 2}}, ...
  'West Turn', 'feature space', 'activation/input/output'), [1, 4]);
gui.addVisualization(MultiPlot({'east.turn', 'east.turn'}, {'activation', 'output'}, ...
  [1, 10], 'horizontal', {'YLim', [-15, 15], 'XGrid', 'on', 'YGrid', 'on'}, ...
  {{'b', 'LineWidth', 3}, {'r', 'LineWidth', 2}, {'Color', [0, 0.75, 0], 'LineWidth', 2}}, ...
  'East Turn', 'feature space', 'activation/input/output'), [2, 4]);

gui.addVisualization(MultiPlot({'ps', 'ps'}, {'activation', 'output'}, ...
  [1, 10], 'horizontal', {'YLim', [-15, 15], 'XGrid', 'on', 'YGrid', 'on'}, ...
  {{'b', 'LineWidth', 3}, {'r', 'LineWidth', 2}, {'Color', [0, 0.75, 0], 'LineWidth', 2}}, ...
  'Proximity sensors', 'feature space', 'activation/input/output'), [2, 5]);

gui.addControl(TimeLabel('Time: %d'),[1,1]);

% add buttons
gui.addControl(GlobalControlButton('Pause', gui, 'pauseSimulation', true, false, false, 'pause simulation'), [1, 4]);
gui.addControl(GlobalControlButton('Reset', gui, 'resetSimulation', true, false, true, 'reset simulation'), [2, 4]);
gui.addControl(GlobalControlButton('Parameters', gui, 'paramPanelRequest', true, false, false, 'open parameter panel'), [3, 4]);
gui.addControl(GlobalControlButton('Record', video, 'record', true, false, false, 'Recod video'), [4, 4]);
gui.addControl(GlobalControlButton('Quit', gui, 'quitSimulation', true, false, false, 'quit simulation'), [6, 4]);

%% Run the simulator in the GUI

if isempty(recordActivation)
  gui.run(inf);
else
  gui.run(max(recordActivation));
  saveRecordedActivation('recordedTurnFields',sim);
end
