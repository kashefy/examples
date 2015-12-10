function localise()
% Localisation example comparing localisation with and without head rotations

warning('off','all');

% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% === Configuration
% Different source positions given by BRIRs
% see:
% http://twoears.aipa.tu-berlin.de/doc/latest/database/impulse-responses/#tu-berlin-telefunken-building-room-auditorium-3
brirs = { ...
    'impulse_responses/qu_kemar_rooms/auditorium3/QU_KEMAR_Auditorium3_src1_xs+0.00_ys+3.97.sofa'; ...
    'impulse_responses/qu_kemar_rooms/auditorium3/QU_KEMAR_Auditorium3_src2_xs+4.30_ys+3.42.sofa'; ...
    'impulse_responses/qu_kemar_rooms/auditorium3/QU_KEMAR_Auditorium3_src3_xs+2.20_ys-1.94.sofa'; ...
    'impulse_responses/qu_kemar_rooms/auditorium3/QU_KEMAR_Auditorium3_src4_xs+0.00_ys+1.50.sofa'; ...
    'impulse_responses/qu_kemar_rooms/auditorium3/QU_KEMAR_Auditorium3_src5_xs-0.75_ys+1.30.sofa'; ...
    'impulse_responses/qu_kemar_rooms/auditorium3/QU_KEMAR_Auditorium3_src6_xs+0.75_ys+1.30.sofa'; ...
    };
headOrientation = 90; % towards y-axis (facing src1)
sourceAngles = [90, 38.5, -41.4, 90, 120, 60] - headOrientation; % phi = atan2d(ys,xs)

% === Initialise binaural simulator
sim = setupBinauralSimulator();

printLocalisationTableHeader();

for ii = 1:length(sourceAngles)

    direction = sourceAngles(ii);

    sim.Sources{1}.IRDataset = simulator.DirectionalIR(brirs{ii});
    sim.rotateHead(headOrientation, 'absolute');
    sim.Init = true;

    % LocationKS with head rotation for confusion solving
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('Blackboard.xml');
    bbs.run();
    % Evaluate localization results
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    [predictedAzimuth1, localisationError1] = ...
        evaluateLocalisationResults(predictedLocations, direction);
    %displayLocalisationResults(predictedLocations, direction)

    % Reset binaural simulation
    sim.rotateHead(headOrientation, 'absolute');
    sim.ReInit = true;

    % LocationKS without head rotation and confusion solving
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('BlackboardNoHeadRotation.xml');
    bbs.run();
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    [predictedAzimuth2, localisationError2] = ...
        evaluateLocalisationResults(predictedLocations, direction);

    printLocalisationTableColumn(direction, ...
                                 predictedAzimuth1 - headOrientation, ...
                                 predictedAzimuth2 - headOrientation);

    sim.ShutDown = true;
end

printLocalisationTableFooter();


end % of main function

function printLocalisationTableHeader()
    fprintf(1, '\n');
    fprintf(1, '------------------------------------------------------------------\n');
    fprintf(1, 'Source direction        Model w head rot.       Model wo head rot.\n');
    fprintf(1, '------------------------------------------------------------------\n');
end

function printLocalisationTableColumn(direction, azimuth1, azimuth2)
    fprintf(1, '%4.0f \t\t\t %4.0f \t\t\t %4.0f\n', ...
            wrapTo180(direction), wrapTo180(azimuth1), wrapTo180(azimuth2));
end

function printLocalisationTableFooter()
    fprintf(1, '------------------------------------------------------------------\n');
end

% vim: set sw=4 ts=4 expandtab textwidth=90 :
