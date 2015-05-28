function localise()
% Localisation example comparing localisation with and without head rotations

warning('off','all');

% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% Different angles the sound source is placed at
%sourceAngles = 0:1:359;
sourceAngles = [0 90 180 270];

% === Initialise binaural simulator
sim = simulator.SimulatorConvexRoom('SceneDescription.xml');
sim.Verbose = false;
sim.Init = true;
sim.LengthOfSimulation = 3;

printLocalisationTableHeader();

% === Initialise model w head rotations
%bbsw = BlackboardSystem(0);
%bbsw.setRobotConnect(sim);
%bbsw.buildFromXml('Blackboard.xml');

% === Initialise model wo head rotations
%bbswo = BlackboardSystem(0);
%bbswo.setRobotConnect(sim);
%bbswo.buildFromXml('BlackboardNoHeadRotation.xml');

% FIXME: the creation of the blackboards should be done outside of the loop in my opinion.
% This is not working at the moment, see: https://dev.qu.tu-berlin.de/issues/1875 and the
% mail to the wp3 mailing list.
for direction = sourceAngles

    sim.Sources{1}.set('Azimuth', direction);
    sim.rotateHead(0, 'absolute');
    sim.ReInit = true;

    % LocationKS with head rotation for confusion solving
    bbsw = BlackboardSystem(0);
    bbsw.setRobotConnect(sim);
    bbsw.buildFromXml('Blackboard.xml');
    bbsw.run();
    % Evaluate localization results
    predictedLocations = bbsw.blackboard.getData('perceivedLocations');
    [predictedAzimuth1, localisationError1] = ...
        evaluateLocalisationResults(predictedLocations, direction);

    sim.rotateHead(0, 'absolute');
    sim.ReInit = true;

    % LocationKS without head rotation and confusion solving
    bbswo = BlackboardSystem(0);
    bbswo.setRobotConnect(sim);
    bbswo.buildFromXml('BlackboardNoHeadRotation.xml');
    bbswo.run();
    predictedLocations = bbswo.blackboard.getData('perceivedLocations');
    [predictedAzimuth2, localisationError2] = ...
        evaluateLocalisationResults(predictedLocations, direction);

    printLocalisationTableColumn(direction, predictedAzimuth1, predictedAzimuth2);

end

printLocalisationTableFooter();

sim.ShutDown = true;

end % of main function

function printLocalisationTableHeader()
    fprintf(1, '\n');
    fprintf(1, '------------------------------------------------------------------\n');
    fprintf(1, 'Source direction        Model w head rot.       Model wo head rot.\n');
    fprintf(1, '------------------------------------------------------------------\n');
end

function printLocalisationTableColumn(direction, azimuth1, azimuth2)
    fprintf(1, '%4.0f \t\t\t %4.0f \t\t\t %4.0f\n', ...
            azimuthInPlusMinus180(direction), ...
            azimuthInPlusMinus180(azimuth1), ...
            azimuthInPlusMinus180(azimuth2));
end

function printLocalisationTableFooter()
    fprintf(1, '------------------------------------------------------------------\n');
end


% vim: set sw=4 ts=4 expandtab textwidth=90 :
