clear all
%% params
T=20; %sium time 
params.m=1; % mass
params.d=1; % frict. coeff
params.d_c=0; % damping coeff
params.K_c=1*eye(2); % spring constant
params.z_star=[10 10]'; % desired distance
params.N=2; % number of agents



% initialize the params bus
params_bus_info = Simulink.Bus.createObject(params);
params_bus = evalin('base',params_bus_info.busName);

%% Initial state
p1_1_0 = 0;
p1_2_0 = 0;
p2_1_0 = 0;
p2_2_0 = 0;
z1_1_0 = 0;
z1_2_0 = 0;

initialCondition = [p1_1_0,p1_2_0,p2_1_0,p2_2_0,z1_1_0,z1_2_0]';