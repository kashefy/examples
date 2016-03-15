function trainAndTestCleanModel( classname )
% TRAINANDTESTCLEANMODEL  Train and test a model to classify sounds
%   TRAINANDTESTCLEANMODEL() train and test a model to classify 'speech'
%   sounds
%   TRAINANDTESTCLEANMODEL(classname) train and test a model to classify
%   classname sounds (e.g. 'speech')
%
if nargin < 1, classname = 'speech'; end;

% Set up the Two!Ears platform with the given configuration file.
% The configuration file checks the compatibility of this example with the
% required Two!Ears modules.
startTwoEars( 'Config.xml' );

pipe = TwoEarsIdTrainPipe(); % instantiate the training pipeline
pipe.featureCreator = featureCreators.FeatureSet1Blockmean(); % specify feature set
pipe.modelCreator = modelTrainers.GlmNetLambdaSelectTrainer( ...
    'performanceMeasure', @performanceMeasures.BAC2, ...
    'cvFolds', 7, ...
    'alpha', 0.99 ); % LASSO
pipe.modelCreator.verbose( 'on' );

pipe.trainset = 'learned_models/IdentityKS/trainTestSets/IEEE_AASP_80pTrain_TrainSet_1.flist';
pipe.testset = 'learned_models/IdentityKS/trainTestSets/IEEE_AASP_80pTrain_TestSet_1.flist';

sc = sceneConfig.SceneConfiguration();
sc.addSource( sceneConfig.PointSource() );
pipe.setSceneConfig( sc ); 

fprintf( ['\nThe pipeline will now initialise, this may involve downloading'...
    ' the training and testing sound files from the online Two!Ears-database, if '...
    'you don''t have a local copy of it and are running this example for the '...
    'first time.\nPress key to continue\n'] );
pause

pipe.init();

fprintf( ['\nThe pipeline is now ready to run. The first time doing so, the processing'...
    ' through binaural simulation, auditory front-end and feature creation '...
    'will take some time. However, you can abort any time - when restarting, '...
    'the pipeline will load the intermediate results (it saves them for this '...
    'reason) and go on at the point where you aborted before. All subsequent '...
    'runs will take much shorter time, as only the actual model training will '...
    'have to be done.\nPress key to continue\n'] );
pause
modelPath = pipe.pipeline.run( {classname}, 0 );

fprintf( ' -- Model is saved at %s -- \n', modelPath );

