%function colorationWfsLinearOffoffcenter()

clear all

startTwoEars('Config.xml');

%% ===== Configuration ===================================================
sourceDir = 'stimuli/anechoic/aipa/';
sourceFiles = { ...
    'music1_48k.wav'; ...
    'speech_48k.wav'; ...
    };
sourceTypes = { ...
    'music'; ...
    'speech'; ...
    };
humanLabelDir = 'experiments/2015-10-01_wfs_coloration/';
humanLabelFiles = { ...
    'human_label_coloration_wfs_linear_offcenter_noise.csv'; ...
    'human_label_coloration_wfs_linear_offcenter_music.csv'; ...
    'human_label_coloration_wfs_linear_offcenter_speech.csv'; ...
    };
brsDir = strcat(humanLabelDir, 'brs/');
brsFiles = { ...
    'wfs_linear_offcenter_ref.wav'; ...
    'wfs_linear_offcenter_stereo.wav'; ...
    'wfs_linear_offcenter_nls0014.wav'; ...
    'wfs_linear_offcenter_nls0028.wav'; ...
    'wfs_linear_offcenter_nls0056.wav'; ...
    'wfs_linear_offcenter_nls0112.wav'; ...
    'wfs_linear_offcenter_nls0224.wav'; ...
    'wfs_linear_offcenter_nls0448.wav'; ...
    'wfs_linear_offcenter_nls0896.wav'; ...
    'wfs_linear_offcenter_anchor.wav'; ...
    };


%% ===== Main ============================================================

% Initialise Binaural Simulator
sim = simulator.SimulatorConvexRoom('SceneDescription.xml');
sim.Verbose = false;

for ii = 1:length(sourceFiles)

    sourceMaterial = audioread(xml.dbGetFile(strcat(sourceDir, sourceFiles{ii})));

    % === Estimate reference
    sim.Sources{1}.IRDataset = simulator.DirectionalIR(strcat(brsDir, brsFiles{1}));
    sim.Sources{1}.setData(sourceMaterial);
    sim.Init = true;
    bbs = BlackboardSystem(1);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('Blackboard.xml');
    bbs.run(); % The ColorationKS runs automatically until the end of the signal
    sim.ShutDown = true;

    % === Estimate coloration for conditions
    for jj = 1:length(brsFiles)
        sim.Sources{1}.IRDataset = simulator.DirectionalIR(fullfile(brsDir, brsFiles{jj}));
        sim.Sources{1}.setData(sourceMaterial);
        sim.Init = true;
        bbs.run()
        prediction(ii,jj) = bbs.blackboard.getLastData('colorationHypotheses').data;
        sim.Sinks.getData();
        sim.ShutDown = true;
    end
    % Scale predictions to be in the range -1..1
    prediction_scaled(ii,:) = prediction(ii,:)./max(prediction(ii,:))*2-1;

end


%% ===== Plot results ====================================================
figure
hold on
conditions = {'ref', 'stereo', '67 cm', '34 cm', '17 cm', '8 cm', '4 cm', '2 cm', ...
              '1 cm', 'anchor'};
colors = {'g','r'};
for ii = 1:length(sourceFiles)
    % === Get results from listening test
    humanLabels = readHumanLabels(fullfile(humanLabelDir, humanLabelFiles{ii}));
    errorbar([humanLabels{:,2}], [humanLabels{:,3}], ['o', colors{ii}]);
    plot(prediction_scaled(ii,:), ['-', colors{ii}]);
end
axis([0 10 -1 1]);
xlabel('System');
ylabel('Coloration');
set(gca, 'XTick', [1:9]);
set(gca, 'XTickLabel', conditions);
title('linear array, offcenter position');

%% ===== Save results ====================================================
for ii = 1:length(sourceFiles)
    fid = fopen(sprintf('evaluation/coloration_linear_offcenter_%s.csv', ...
                sourceTypes{ii}), 'w');
    fprintf(fid, strcat('# system, human_label, confidence_interval, model\n'));
    for jj = 1:length(brsFiles)
        fprintf(fid, '"%s", %5.2f, %5.2f, %5.2f, %5.2f\n', brsFiles{jj}, ...
                humanLabels{jj,2}, humanLabels{jj,3}, prediction_scaled(ii,jj));
    end
    fclose(fid);
end
% vim: set sw=4 ts=4 et tw=90:
