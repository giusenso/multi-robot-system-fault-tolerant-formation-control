clear all

%% params
T = 20; % running time 

params.N    = 2;        % number of agents
params.m    = [1;1];    % masses
params.d    = [1;1];    % frict. coeff

params.E    = 1;        % number of edges
params.B    = [1;-1];    % incidence matrix
params.dc	= [0;0];     % damping coeff
params.kc	= [1;1];     % spring constant
params.z_des= [10;10];  % desired distance

% initialize the params bus
params_bus_info = Simulink.Bus.createObject(params);
params_bus = evalin('base',params_bus_info.busName);

%% Initial state
p0 = [[0;0]; [0;0]];
z0 = [0;0];
initialCondition = [p0;z0];