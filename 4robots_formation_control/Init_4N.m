clear all

%% params
T = 20; % running time 

n = 3;  % task space
params.N    = 4;                % number of agents
params.m    = [10;10;10;10];    % masses
params.d    = [8;8;8;8];        % frict. coeff

params.E    = 4;                % number of edges
params.B    = [-1 0 0 +1; 1 -1 0 0; 0 1 -1 0; 0 0 1 -1];  % incidence matrix
params.dc	= [0;0;0;0];        % damping coeff
params.kc	= [10;10;10;10];    % spring constant
params.z_des= [ [-10;0;0];
                [0;-10;0];
                [10;0;0];
                [0;10;0]];    % desired distance

params.gain = zeros(n*params.N,1);
for i = 1:params.N
    params.gain(n*i-n+1:n*i) = ones(n,1)*(1/params.m(i));
end
clear i

% initialize the params bus
params_bus_info = Simulink.Bus.createObject(params);
params_bus = evalin('base',params_bus_info.busName);

%% Initial conditions
p0 = zeros(n*params.N, 1);
z0 = zeros(n*params.E, 1);
q0 = zeros(n*params.N, 1);

initialCondition = [p0; z0; q0];
