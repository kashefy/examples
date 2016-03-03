function bbs = localise()
% Localisation example comparing localisation with and without head rotations

warning('off','all');

% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% === Initialise binaural simulator
sim = simulator.SimulatorConvexRoom('AnechoicScene.xml');
sim.Verbose = false;
sim.Init = true;

%printLocalisationTableHeader();

masker1 = 'sound_databases/BUHRC_monosyllabic_words/BUG_T01_1_2.wav';
masker2 = 'sound_databases/BUHRC_monosyllabic_words/BUG_T03_4_2.wav';
target  = 'sound_databases/BUHRC_monosyllabic_words/BUG_T09_1_3.wav';

for direction = 0

    set(sim.Sources{1}.AudioBuffer, 'File', target);
    set(sim.Sources{2}.AudioBuffer, 'File', masker1);
    set(sim.Sources{3}.AudioBuffer, 'File', masker2);
    sim.rotateHead(0, 'absolute');
    sim.ReInit = true;

    % GmtkLocationKS with head rotation for confusion solving
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('BlackboardLocalisation.xml');
    bbs.run();
    % Evaluate localization results
    predictedAzimuths = bbs.blackboard.getData('perceivedAzimuths');
    predictedAzimuth = evaluateLocalisationResults(predictedAzimuths, direction);
    displayLocalisationResults(predictedAzimuths, direction)

    %printLocalisationTableColumn(direction, predictedAzimuth);

end

%printLocalisationTableFooter();

sim.ShutDown = true;

% Get signal
sigObj = bbs.getAfeData('time');
sig = [sigObj{1}.getSignalBlock(1) sigObj{2}.getSignalBlock(1)];
audiowrite('debug.wav', sig, 16000);


end % of main function

function printLocalisationTableHeader()
    fprintf(1, '\n');
    fprintf(1, '-----------------------------------------\n');
    fprintf(1, 'Source direction        Model w head rot.\n');
    fprintf(1, '-----------------------------------------\n');
end

function printLocalisationTableColumn(direction, azimuth1, azimuth2)
    fprintf(1, '%4.0f \t\t\t %4.0ff\n', ...
            wrapTo180(direction), wrapTo180(azimuth1));
end

function printLocalisationTableFooter()
    fprintf(1, '-----------------------------------------\n');
end

% vim: set sw=4 ts=4 expandtab textwidth=90 :
