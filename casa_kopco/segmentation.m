function bbs = localise()
% Localisation example comparing localisation with and without head rotations


%% ===== Configuration ===================================================
% Apply priming
usepriming = false;
primed_positions = [5 90 -90];


%% ===== Main ============================================================
warning('off','all');

% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

% === Initialise binaural simulator
sim = simulator.SimulatorConvexRoom('AnechoicScene.xml');
sim.Verbose = false;
sim.Init = true;

masker1 = 'sound_databases/BUHRC_monosyllabic_words/BUG_T01_1_2.wav';
masker2 = 'sound_databases/BUHRC_monosyllabic_words/BUG_T03_4_2.wav';
target  = 'sound_databases/BUHRC_monosyllabic_words/BUG_T09_1_3.wav';


set(sim.Sources{1}.AudioBuffer, 'File', target);
set(sim.Sources{2}.AudioBuffer, 'File', masker1);
set(sim.Sources{3}.AudioBuffer, 'File', masker2);
sim.rotateHead(0, 'absolute');
sim.ReInit = true;

% Run SegmentationKS
bbs = BlackboardSystem(0);
bbs.setRobotConnect(sim);
bbs.buildFromXml('BlackboardSegmentation.xml');
if usepriming
    bbs.blackboard.KSs{2}.setFixedPositions(deg2rad(primed_positions));
end
bbs.run();
sim.ShutDown = true;

% Evaluate results
hypotheses = bbs.blackboard.data.values;

figure
for k = 1 : 3
    % Get hypotheses for current source
    softMask = hypotheses{end}.segmentationHypotheses(k).softMask;
    position = hypotheses{end}.sourceAzimuthHypotheses(k).sourceAzimuth;

    % Convert position from [rad] to [deg]
    position = position * 180 / pi;

    % Get number of frames/channels and compute time and frequency-scales
    [nFrames, nChannels] = size(softMask);
    timescale = linspace(0, sim.LengthOfSimulation, nFrames);
    freqscale = 1 : nChannels;

    subplot (1, 3, k)
    imagesc(timescale, freqscale, softMask');
    set(gca, 'YDir', 'normal');
    axis square;
    colorbar;
    caxis([0, 1]);
    xlabel('Time / [s]');
    ylabel('Channel index');
    title(['Estimated soft mask for source at ', num2str(position), '°.'])
end

% vim: set sw=4 ts=4 expandtab textwidth=90 :
