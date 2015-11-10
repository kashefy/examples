function [predictedAzimuth, localisationError] = ...
    benchmarkAgainstDietz2011(binauralSimulation, sourceAzimuth)
%benchmarkAgainstDietz2011 uses dietz2011() from the AMToolbox to calculate the direction
%                          of the auditory event
%
%   USAGE
%       predictedAzimuth, localisationError] = ...
%           benchmarkAgainstDietz2011(binauralSimulation, sourceAzimuth)
%
%   INPUT PARAMETERS
%       binauralSimulation  - binaural simulation object
%       sourceAzimuth       - horizontal direction of sound event
%
%   OUTPUT PARAMETERS
%       predictedAzimuth    - horizintal direction of auditory event
%       localisationError   - difference between direction of auditory and sound event
%
%   DETAILS
%       This function utilises the implementation of the Dietz (2011) model from the
%       auditory modeling toolbox (http://amtoolbox.sourceforge.net/) to predict the
%       horizontal direction of the auditory event. It works with a simple lookup table
%       for the ITD values between 100 Hz and 1000Hz. Those lookup table is loaded from
%       the Two!Ears database.

% Load ITD<->Azimuth lookup table
load(xml.dbGetFile('learned_models/lookupDietz.mat'));
lookupTable = lookup_table;

% Run simulation and get binaural signal
while ~binauralSimulation.isFinished()
    binauralSimulation.set('Refresh', true);
    binauralSimulation.set('Process', true);
end
binauralSignal = binauralSimulation.Sinks.getData();
binauralSimulation.Sinks.removeData();

% Use Dietz (2011) model to predict perceived direction
if ~exist('wierstorf2013estimateazimuth')
    error('%s: You have to install and start the AMToolbox first.', mfilename);
end
predictedAzimuth = wierstorf2013estimateazimuth(binauralSignal, lookupTable);
localisationError = localisationErrors(sourceAzimuth, predictedAzimuth);

% vim: set sw=4 ts=4 expandtab textwidth=90 :
