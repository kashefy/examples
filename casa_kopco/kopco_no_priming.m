function kopco_no_priming()
% Localisation example comparing localisation with and without head rotations

%warning('off','all');
startTwoEars('Config.xml');

%% ===== Configuration ====================================================
masker1 = 'sound_databases/BUHRC_monosyllabic_words/BUG_T01_1_2.wav';
masker2 = 'sound_databases/BUHRC_monosyllabic_words/BUG_T03_4_2.wav';
target  = 'sound_databases/BUHRC_monosyllabic_words/BUG_T09_1_3.wav';


%% ===== Main =============================================================

% --- Estimate positons of sources ---
sim = startBinSim('AnechoicScene.xml', target, masker1, masker2);
% Get distribution from LocationKS
% FIXME: at the moment head rotation is disabled for this stage, we first have to
% check if ConfusionSolvingKS also works for more than one source
bbs = startBlackboard(sim, 'BlackboardLocalisation1.xml');
bbs.run();
sim.ShutDown = true;
bbsData = bbs.blackboard.getData('sourcesAzimuthsDistributionHypotheses');
% Find azimuth of the three sources by peaks in distribution
[~,idx] = sort(bbsData(end).data.sourcesDistribution,'descend');
azimuths = bbsData(end).data.azimuths(idx(1:3));

% --- Do segmentation after the given source positions ---
sim = startBinSim('AnechoicScene.xml', target, masker1, masker2);
bbs = startBlackboard(sim, 'BlackboardSegmentation.xml');
bbs.blackboard.KSs{2}.setFixedPositions(wrapTo180(azimuths)/180*pi); % provide knowledge about positions
bbs.run();
sim.ShutDown = true;
bbsData = bbs.blackboard.data.values;
segmentation = bbsData{end}.segmentationHypotheses;

% --- Identify the target ---
% FIXME: this cannot be done at the moment.
% I would use the female vs. male together iwth IdentityKS for this task
% The softmasks have also to be applied to the signals

% --- Localise the target again ---
% This time we use the segmentation mask apply it to the input signal and run the
% LocationKS again (this time with head rotation)
sim = startBinSim('AnechoicScene.xml', target, masker1, masker2);
bbs = startBlackboard(sim, 'BlackboardLocalisation2.xml');
% FIXME: howto apply the softmaks to GmmLocationK?
sim.ShutDown = true;

end % of main function


%% ===== Functions ========================================================
% Start binaural simulator with n sources and xml scene
function sim = startBinSim(scene, varargin)
    sim = simulator.SimulatorConvexRoom(scene);
    sim.Verbose = false;
    for ii=2:nargin
        set(sim.Sources{ii-1}.AudioBuffer, 'File', varargin{ii-1});
    end
    sim.rotateHead(0, 'absolute');
    sim.Init = true;
end
% Run Blackboard for given xml configuration
function bbs = startBlackboard(sim, config)
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml(config);
end

% vim: set sw=4 ts=4 expandtab textwidth=90 :
