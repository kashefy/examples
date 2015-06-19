function localise()
% Localisation example comparing two different HRTFs

warning('off','all');

% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% Different angles the sound source is placed at
sourceAngles = [0 88 175 257];

% === Initialise binaural simulator
simQu = simulator.SimulatorConvexRoom('SceneDescriptionQU.xml');
simQu.Verbose = false;
simQu.Init = true;
simMit = simulator.SimulatorConvexRoom('SceneDescriptionMIT.xml');
simMit.Verbose = false;
simMit.Init = true;

printLocalisationTableHeader();

for direction = sourceAngles

    % Localisation using QU KEMAR HRTFs
    simQu.Sources{1}.set('Azimuth', direction);
    simQu.rotateHead(0, 'absolute');
    simQu.ReInit = true;
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(simQu);
    bbs.buildFromXml('BlackboardQU.xml');
    bbs.run();
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    predictedAzimuthQu = evaluateLocalisationResults(predictedLocations, direction);

    % Localisation using MIT KEMAR HRTFs
    simMit.Sources{1}.set('Azimuth', direction);
    simMit.rotateHead(0, 'absolute');
    simMit.ReInit = true;
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(simMit);
    bbs.buildFromXml('BlackboardMIT.xml');
    bbs.run();
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    predictedAzimuthMit = evaluateLocalisationResults(predictedLocations, direction);

    printLocalisationTableColumn(direction, predictedAzimuthQu, predictedAzimuthMit);

end

printLocalisationTableFooter();

sim.ShutDown = true;

end % of main function

function printLocalisationTableHeader()
    fprintf(1, '\n');
    fprintf(1, '------------------------------------------------------------------\n');
    fprintf(1, 'Source direction        Model w QU HRTF       Model w MIT HRTF\n');
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
