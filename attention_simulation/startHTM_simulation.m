% === Parameters of the simulation

% --- Take all audiovisual pairs
htm_path = '../../audio-visual-integration/head_turning_modulation_model_simdata';

addpath(genpath(htm_path));

htm = HeadTurningModulationKS('Save', true);

% --- The simulation can take some time (depending on the complexity of the scenario simulated).
% --- Don't bother checking regularly if the simulation is over: a notification is played once it is ;)

RIR = htm.RIR;
env = getEnvironment(htm, 0);
MFI = htm.MFI;
DW = htm.DW;
MSOM = htm.MSOM;

ODKS = htm.ODKS;
FCKS = htm.FCKS;
MOKS = htm.MOKS;

% --- Once the simulation is over, statistics on the HTM performances are computed.
% --- 'plotGoodClassif': will plot the average good classification over time versus a naive fusion algorithm (to be changed soon)
% --- 'plotGoodClasssifObj': same as above but with the possibility to focus on given objects
% --- 'plotSHM': will plot the number of head movements triggered by the HTM versus a naive robot
% --- 'plotHits': will plot the state of the MSOM at the end of the simulation. Helps observe the tonotopy of the network.

% plotGoodClassif(htm, 'Max', true, 'Rect', false);
