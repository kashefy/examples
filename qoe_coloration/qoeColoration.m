%function qoeColoration()

% Two!Ears script for Quality of Experience scenario 4
% 
% Goal of this scenario is to benchmark different coloration models against human data for
% a point source synthesized with Wave Field Synthesis (Wierstorf et al, 2014).
%
% Reference:
%   Wierstorf, Hohnerlein, Spors, Raake - Coloration in Wave Field Synthesis, 55th AES
%   International Conference, Paper 5-3

clear all


startTwoEars('Config.xml');

%% ===== Configuration ===================================================
humanLabelDir = fullfile('experiments', '2015-10-01_wfs_coloration');
humanLabelFiles = { ...
    %'human_label_coloration_wfs_circular_center_noise.csv'; ...
    'human_label_coloration_wfs_circular_center_music.csv'; ...
    %'human_label_coloration_wfs_circular_center_speech.csv'; ...
    };
brsDir = fullfile(humanLabelDir, 'brs');
brsFiles = { ...
    'wfs_circular_center_ref.wav'; ...
    'wfs_circular_center_anchor.wav'; ...
    'wfs_circular_center_stereo.wav'; ...
    'wfs_circular_center_nls0014.wav'; ...
    'wfs_circular_center_nls0028.wav'; ...
    'wfs_circular_center_nls0056.wav'; ...
    'wfs_circular_center_nls0112.wav'; ...
    'wfs_circular_center_nls0224.wav'; ...
    'wfs_circular_center_nls0448.wav'; ...
    'wfs_circular_center_nls0896.wav'; ...
    };


% === Initialise binaural simulator and learn reference
sim = simulator.SimulatorConvexRoom('SceneDescription.xml');
sim.Verbose = false;
sim.Init = true;
% The Binaural SImulator is initialized with the reference condition for music, so we
% learn this first
bbs = BlackboardSystem(1);
bbs.setRobotConnect(sim);
bbs.buildFromXml('Blackboard.xml');
bbs.run(); % The ColorationKS runs automatically until the end of the signal
sim.Sinks.getData();
sim.ShutDown = true;

% === Get results from listening test
humanLabels = readHumanLabels(fullfile(humanLabelDir, humanLabelFiles{1}));



% === Estimate coloration for conditions
for ii=1:length(brsFiles)

    brsFiles{ii}
    sim.Sources{1}.IRDataset = simulator.DirectionalIR(fullfile(brsDir, brsFiles{ii}));
    sim.Init = true;
    bbs.run()
    result(ii) = bbs.blackboard.getLastData('colorationHypotheses').data;
    sim.Sinks.getData();
    sim.ShutDown = true;

end

return



% Read wav files
color = zeros(10, length(stimuliType));
colorMoore = zeros(10, length(stimuliType));
for jj=1:length(stimuliType)
    %[fileNames,nFiles] = readFileList( ...
    %    strcat('experiments/aipa_sound_field_synthesis/coloration/', ...
    %           'center_position_with_headphone_compensation_', stimuliType{jj}, '.flist'));

    % Get human labels
    humanLabels = readHumanLabels( ...
        strcat('experiments/2015-10-01_wfs_coloration/', ...
               'human_label_coloration_wfs_circular_center_', ...
               stimuliType{jj}, '.csv'));
    fileNames = humanLabels(:,1);
    nFiles = size(humanLabels,1);

    % Process Reference
    refWavSignal = wavread(xml.dbGetFile(fileNames{2}), sigLength);
    refSignal = dataObject(refWavSignal,fs);
    refManager = manager(refSignal,requests,parameters);
    refManager.processSignal();
    centerFreqs = refSignal.gammatone{1}.cfHz;
    refExcitationPatternLeft = refSignal.gammatone{1}.Data(:,:);
    refExcitationPatternRight = refSignal.gammatone{2}.Data(:,:);

    % Calculate D differences for all test files
    for ii=3:nFiles
        testWavSignal = wavread(xml.dbGetFile(fileNames{ii}), sigLength);
        % Adjust gain
        gain = db(rms(testWavSignal(:))) - db(rms(refWavSignal(:)));
        testWavSignal = testWavSignal .* 10^(-gain / 20);
        testSignal = dataObject(testWavSignal, fs);
        testManager = manager(testSignal, requests, parameters);
        testManager.processSignal();
        % excitation pattern
        testExcitationPatternLeft = testSignal.gammatone{1}.Data(:,:);
        testExcitationPatternRight = testSignal.gammatone{2}.Data(:,:);
        % Moore + Tan naturalness model
        colorMoore(ii-2,jj) = colorationMooreTan2003(testExcitationPatternLeft, refExcitationPatternLeft);
        % Model after Ende (2014)
        %D = colorationEnde2014();
        % Two!Ears model
        color(ii-2,jj) = coloration(testExcitationPatternLeft, ...
                                    testExcitationPatternRight, ...
                                    refExcitationPatternLeft, ...
                                    refExcitationPatternRight);
    end

    % Plot results
    figure
    conditions = {'stereo', '0.3 cm', '0.5 cm', '1 cm', '2 cm', '4 cm', '8 cm', '17 cm', ...
                  '34 cm', '67 cm'};
    errorbar([humanLabels{3:12,2}], [humanLabels{3:12,3}], 'or'); hold on
    plot(color(:,jj) / 50 - 0.9, '-r');
    plot(colorMoore(:,jj) - 1.2, '-b');
    axis([0 11 -1 1]);
    xlabel('System');
    ylabel('Coloration');
    set(gca, 'XTick', [1:10]);
    set(gca, 'XTickLabel', conditions);
    title(sprintf('WFS coloration, %s', stimuliType{jj}));

    % Save results
    fid = fopen(sprintf('evaluation/coloration_%s.csv', stimuliType{jj}), 'w');
    fprintf(fid, strcat('# system, human_color, confidence_interval, ', ...
        'Two!Ears model, Moore-Tan-model\n'));
    for nn = 1:length(conditions)
        fprintf(fid, '"%s", %5.2f, %5.2f, %5.2f, %5.2f\n', conditions{nn}, ...
            humanLabels{nn+2,2}, humanLabels{nn+2,3}, color(nn,jj) / 50 - 0.9, ...
            colorMoore(nn,jj) - 1.2);
    end
    fclose(fid);
end
% vim: set sw=4 ts=4 et tw=90:
