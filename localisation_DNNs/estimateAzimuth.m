function phi = estimateAzimuth(sim, blackboardConfig)
%estimateAzimuth Runs a Blackboard for the given Binaural Simulator and
%                Blackboard configuration file
%
%   USAGE
%       estimateAzimuth(sim, blackboardConfig)
%
%   INPUT PARAMETERS
%       sim              - Binaural simulator object
%       blackboardConfig - blackboard configuration xml file (string)


bbs = BlackboardSystem(0);
bbs.setRobotConnect(sim);
bbs.buildFromXml(blackboardConfig);
bbs.run();
% Evaluate localization results
predictedLocations = bbs.blackboard.getData('perceivedLocations');
phi = evaluateLocalisationResults(predictedLocations);
%displayLocalisationResults(predictedLocations, direction)
