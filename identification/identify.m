function bbs = identify(idModels)
%IDENTIFY identifies sources positioned at 0 deg and returns the blackboard object

if nargin < 1, idModels = setDefaultIdModels(); end

%warning('off', 'all');

% === Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% === load test sounds
[sourceSignal, labels, onOffsets] = makeTestSignal(idModels);

% === Initialise binaural simulator
sim = simulator.SimulatorConvexRoom('SceneDescription.xml');
sim.Verbose = false;
sim.Init = true;
sim.Sources{1}.set('Azimuth', 0);
sim.rotateHead(0, 'absolute');
sim.ReInit = true;
sim.Sources{1}.setData(sourceSignal);

% === Initialise and run model
bbs = buildIdentificationBBS(sim,idModels,labels,onOffsets);
bbs.run();

% === Evaluate scores
idScoresRelativeError(bbs,labels,onOffsets);

% finish
sim.ShutDown = true;


% vim: set sw=4 ts=4 expandtab textwidth=90 :
