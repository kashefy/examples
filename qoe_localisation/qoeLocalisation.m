function qoeLocalisation()
% qoeLocalisation() computes directions of auditory event of synthesized sound fields and
%                   compares them to humam data from listening experiments
%
%   USAGE
%       qoeLocalisation()
%


%% ===== Configuration ===================================================
% Listening experiment files
humanLabelFiles = { ...
    %'experiments/2013-11-01_sfs_localisation/human_label_localization_wfs_ps_linear.txt'; ...
    'experiments/2013-11-01_sfs_localisation/human_label_localization_wfs_ps_circular.txt'; ...
    %'experiments/2013-11-01_sfs_localisation/human_label_localization_nfchoa_ps_circular.txt'; ...
    %'experiments/2013-11-01_sfs_localisation/human_label_localization_wfs_pw_circular.txt'; ...
    %'experiments/2013-11-01_sfs_localisation/human_label_localization_nfchoa_pw_circular.txt'; ...
    %'experiments/2013-11-01_sfs_localisation/human_label_localization_wfs_fs_circular.txt'; ...
    };
% Binaural simulation files
binSimFile = 'experiments/2013-11-01_sfs_localisation/2013-11-01_sfs_localisation.xml';


%% ===== Main ============================================================
% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

for jj = 1:length(humanLabelFiles)
    fprintf(1, '\nPROCESS HUMAN LABEL FILE: %s\n', humanLabelFiles{jj});

    % Open file to store evaluation results (for plotting with gnuplot)
    [~, expFile] = fileparts(humanLabelFiles{jj});
    outFile1 = sprintf('data/%s.csv', expFile);
    outFile2 = sprintf('data/%s_dietz.csv', expFile);
    outFile3 = sprintf('data/%s_twoears.csv', expFile);
    fid1 = fopen(outFile1, 'w');
    fid2 = fopen(outFile2, 'w');
    fid3 = fopen(outFile3, 'w');

    % Get human labels
    humanLabels = readHumanLabels(humanLabelFiles{jj});

    fprintf(1, '\n');
    fprintf(1, '--------------------------------------------------------------------------------------------\n');
    fprintf(1, 'condition \t\t\t\t\t experiment \t Dietz \t\t LocationKS\n');
    fprintf(1, '--------------------------------------------------------------------------------------------\n');
    fprintf(fid1, '# condition, X, Y, phi/deg, phi_error/deg\n');
    fprintf(fid2, '# condition, X, Y, phi/deg, phi_error/deg\n');
    fprintf(fid3, '# condition, X, Y, phi/deg, phi_error/deg\n');

    for ii = 1:size(humanLabels, 1)

        brsFile = humanLabels{ii,1};
        headRotationOffset = humanLabels{ii,9};
        X = humanLabels{ii,2};
        Y = humanLabels{ii,3};
        % Check if more than one source was perceived by the listener
        if length(humanLabels{ii,4})>1
            % Ignore it by claculating the average location for now
            %perceivedAzimuth = mean([humanLabels{ii,4}(:)]) - headRotationOffset;
            % Ignore it by using only the first entry
            perceivedAzimuth = humanLabels{ii,4}(1) - headRotationOffset;
            physicalAzimuth = perceivedAzimuth - humanLabels{ii,5}(1);
        else
            perceivedAzimuth = humanLabels{ii,4} - headRotationOffset;
            physicalAzimuth = perceivedAzimuth - humanLabels{ii,5};
        end

        % Start binaural simulation
        sim = simulator.SimulatorConvexRoom(binSimFile);
        sim.Sources{1}.IRDataset = simulator.DirectionalIR(brsFile); % load BRS file
        sim.Verbose = false;
        sim.Init = true;
        sim.LengthOfSimulation = 5;
        sim.rotateHead(0, 'absolute');

        % Benchmark against Dietz (2011)
        [predictedAzimuthDietz(ii), localisationErrorDietz(ii)] = ...
            benchmarkAgainstDietz2011(sim, physicalAzimuth);

        sim.ReInit = true;

        % Setup blackboard system
        bbs = BlackboardSystem(0);
        bbs.setRobotConnect(sim);
        bbs.buildFromXml('Blackboard.xml');
        % Run blackboard
        bbs.run();

        % Evaluate localization results
        predictedLocations = bbs.blackboard.getData('perceivedLocations');
        [predictedAzimuth(ii), localisationError(ii)] = ...
            evaluateLocalisationResults(predictedLocations, physicalAzimuth);
        %displayLocalisationResults(predictedLocations, perceivedAzimuth);

        sim.ShutDown = true;

        % Display results
        [~, condition] = fileparts(brsFile);
        fprintf(1, '%s\t %4.0f deg\t %4.0f deg\t %4.0f deg\n', condition, perceivedAzimuth, ...
            predictedAzimuthDietz(ii), wrapTo180(predictedAzimuth(ii)));
        fprintf(fid1, '"%s", \t %5.2f, %5.2f, %4.0f, %4.0f\n', condition, X, Y, ...
            wrapTo180(perceivedAzimuth + headRotationOffset), ...
            wrapTo180(perceivedAzimuth - physicalAzimuth));
        fprintf(fid2, '"%s", \t %5.2f, %5.2f, %4.0f, %4.0f\n', condition, X, Y, ...
            wrapTo180(predictedAzimuthDietz(ii) + headRotationOffset), ...
            wrapTo180(predictedAzimuthDietz(ii) - physicalAzimuth));
        fprintf(fid3, '"%s", \t %5.2f, %5.2f, %4.0f, %4.0f\n', condition, X, Y, ...
            wrapTo180(predictedAzimuth(ii) + headRotationOffset), ...
            wrapTo180(predictedAzimuth(ii) - physicalAzimuth));

    end

    fprintf(1, '--------------------------------------------------------------------------------------------\n');
    fprintf(1, '\n\n');
    fclose(fid1);
    fclose(fid2);
    fclose(fid3);

end
% vim: set sw=4 ts=4 expandtab textwidth=90 :
