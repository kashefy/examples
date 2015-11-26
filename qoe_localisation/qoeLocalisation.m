%function qoeLocalisation()
% qoeLocalisation() computes directions of auditory event of synthesized sound fields and
%                   compares them to humam data from listening experiments
%
%   USAGE
%       qoeLocalisation()
%


%% ===== Configuration ===================================================
% Listening experiment files
humanLabelFile = ...
    'experiments/2013-11-01_sfs_localisation/human_label_localization_wfs_ps_circular.txt';
% Binaural simulation files
binSimFile = 'experiments/2013-11-01_sfs_localisation/2013-11-01_sfs_localisation.xml';


%% ===== Main ============================================================
% Initialize Two!Ears model and check dependencies
startTwoEars('Config.xml');

fprintf(1, '\nPROCESS HUMAN LABEL FILE: %s\n', humanLabelFile);

% Get human labels
humanLabels = readHumanLabels(humanLabelFile);

fprintf(1, '\n');
fprintf(1, '----------------------------------------------------------------------------------\n');
fprintf(1, 'condition \t\t\t\t\t experiment \t ItdLocationKS\n');
fprintf(1, '----------------------------------------------------------------------------------\n');

for ii = 1:size(humanLabels, 1)

    brsFile = humanLabels{ii,1};
    headRotationOffset = humanLabels{ii,9};
    % Check if more than one source was perceived by the listener
    if length(humanLabels{ii,4})>1
        % Ignore it by claculating the average location for now
        %perceivedAzimuth = mean([humanLabels{ii,4}(:)]) - headRotationOffset;
        % Ignore it by using only the first entry
        perceivedAzimuth(ii) = humanLabels{ii,4}(1) - headRotationOffset; % phi-phi_offset
        physicalAzimuth(ii) = perceivedAzimuth(ii) - humanLabels{ii,5}(1);%    -phi_error
    else
        perceivedAzimuth(ii) = humanLabels{ii,4} - headRotationOffset;
        physicalAzimuth(ii) = perceivedAzimuth(ii) - humanLabels{ii,5};
    end

    % Start binaural simulation
    sim = simulator.SimulatorConvexRoom(binSimFile);
    sim.Sources{1}.IRDataset = simulator.DirectionalIR(brsFile); % load BRS file
    sim.Verbose = false;
    sim.Init = true;
    sim.LengthOfSimulation = 5;
    sim.rotateHead(0, 'absolute');

    % Setup blackboard system
    bbs = BlackboardSystem(0);
    bbs.setRobotConnect(sim);
    bbs.buildFromXml('BlackboardNoHeadRotation.xml');
    % Run blackboard
    bbs.run();

    % Evaluate localization results
    predictedLocations = bbs.blackboard.getData('perceivedLocations');
    [predictedAzimuth(ii), localisationError(ii)] = ...
        evaluateLocalisationResults(predictedLocations, physicalAzimuth(ii));
    %displayLocalisationResults(predictedLocations, perceivedAzimuth);

    sim.ShutDown = true;

    % Display results
    [~, condition] = fileparts(brsFile);
    fprintf(1, '%s\t %4.0f deg\t %4.0f deg\n', condition, ...
        wrapTo180(perceivedAzimuth(ii) + headRotationOffset), ...
        wrapTo180(predictedAzimuth(ii) + headRotationOffset));

end

fprintf(1, '--------------------------------------------------------------------------------------------\n');
fprintf(1, '\n\n');

% Plot results
X = [humanLabels{:,2}];
Y = [humanLabels{:,3}];
figure;
% listening test
[u,v,~] = pol2cart(deg2rad(perceivedAzimuth+90),ones(1,48),zeros(1,48));
subplot(2,3,1);
quiver(X(1:16),Y(1:16),u(1:16),v(1:16),0.5);
axis equal
axis([-2.3 2.3 -2 2.6])
title('experiment, 14 loudspeakers');
xlabel('x/m');
ylabel('y/m');
subplot(2,3,2);
quiver(X(17:32),Y(17:32),u(17:32),v(17:32),0.5);
axis equal
axis([-2.3 2.3 -2 2.6])
title('experiment, 28 loudspeakers');
xlabel('x/m');
ylabel('y/m');
subplot(2,3,3);
quiver(X(33:48),Y(33:48),u(33:48),v(33:48),0.5);
axis equal
axis([-2.3 2.3 -2 2.6])
title('experiment, 56 loudspeakers');
xlabel('x/m');
ylabel('y/m');
% model
[u,v,~] = pol2cart(deg2rad(predictedAzimuth+90),ones(1,48),zeros(1,48));
subplot(2,3,4);
quiver(X(1:16),Y(1:16),u(1:16),v(1:16),0.5);
axis equal
axis([-2.3 2.3 -2 2.6])
title('model, 14 loudspeakers');
xlabel('x/m');
ylabel('y/m');
subplot(2,3,5);
quiver(X(17:32),Y(17:32),u(17:32),v(17:32),0.5);
axis equal
axis([-2.3 2.3 -2 2.6])
title('model, 28 loudspeakers');
xlabel('x/m');
ylabel('y/m');
subplot(2,3,6);
quiver(X(33:48),Y(33:48),u(33:48),v(33:48),0.5);
axis equal
axis([-2.3 2.3 -2 2.6])
title('model, 56 loudspeakers');
xlabel('x/m');
ylabel('y/m');


% vim: set sw=4 ts=4 expandtab textwidth=90 :
