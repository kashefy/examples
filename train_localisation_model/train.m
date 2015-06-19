function train()
% This will train the localisation stage with the MIT data set

warning('off','all');

% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% Get LocationKS in training mode
bTrain = true;
angularResolution = 5;
loc = LocationKS('mit', angularResolution, bTrain);

% Generate binaural signals and extract ITD, ILD for learning.
% The used HRTF set, audio material and signal length are specified in the scene
% configuration file SceneDescriptionMIT.xml
loc.generateTrainingData('SceneDescriptionMIT.xml');

% Train model
loc.train();

% Remove unneeded data
loc.removeTrainingData();

% vim: set sw=4 ts=4 expandtab textwidth=90 :
