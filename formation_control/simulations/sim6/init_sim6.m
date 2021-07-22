clear all
close all

T = 120; % running time
params.faulted_robot = 4;

%% Robots
n = 3;                          % task space
params.N    = 5;                % number of agents
params.m    = [10;10;10;10;10];	% masses
params.d    = [6;6;6;6;6];      % frict. coeff

%% Edges
% complete incidence matrix
params.Bfull= [ -1	0	0	0	1	-1  0   0   1   0; 
                1	-1	0	0   0   0   -1  0   0   1;
                0	1   -1  0   0   1   0   -1  0   0;
                0   0   1   -1  0   0   1   0   -1  0;
                0   0   0   1   -1	0   0   1   0   -1];

% initial incidence matrix
params.B =    [ -1	0	0	0	1	-1	0	0	1   0; 
                1	-1	0	0   0   0   0   0   0   0;
                0	1   -1  0   0   1   0   0   0   0;
                0   0   1   -1  0   0   0   0   -1  0;
                0   0   0   1   -1	0   0   0   0   0];

params.E = size(params.Bfull,2);	% number of edges
E_max = params.N*(params.N-1)/2;
%if(params.E < E_max)
%    fprintf('ERROR: Incedence matrix is not complete. Graph must have %d edges!',E_max);
%end
params.dc	= 10*ones(params.E,1);	% damping coeff
params.kc	= 10*ones(params.E,1);	% spring constant

%% Desired edges length
d = 20;
beta = (2*pi)/params.N;
alpha = - beta/2;
params.z_des = zeros(n*params.E,1);
for i = 1:params.E
    if(i<=params.N)
        params.z_des(i*n-n+1:i*n) = ...
            [d*cos(alpha-(i-1)*beta); d*sin(alpha-(i-1)*beta); 0];
    else
        k = i-params.N;
        params.z_des(i*n-n+1:i*n) = ...
            params.z_des(k*n-n+1:k*n) + params.z_des((k+1)*n-n+1:(k+1)*n);
    end
end

%% Tanks
params.tank_size = 100;
params.tank_thresh = 0.25;   
params.tank_max = params.tank_size*(1+params.tank_thresh);
params.tank_min = params.tank_size*(1-params.tank_thresh);
params.fault_occurred = 0;
params.gamma = 10^(-4)*ones(params.E,1);	% rate of exchange of energy

params.gain = zeros(n*params.N,1);
for i = 1:params.N
    params.gain(n*i-n+1:n*i) = ones(n,1)*(1/params.m(i));
end
clear i

%% initialize the params bus
params_bus_info = Simulink.Bus.createObject(params);
params_bus = evalin('base',params_bus_info.busName);

%% Initial conditions
p0 = zeros(n*params.N,1);

r = 5;
beta = (2*pi)/params.N;
q0 = zeros(n*params.N, 1);
for i = 1:params.N
    q0(n*i-n+1:n*i) = [r*cos(pi/2-(i-1)*beta); r*sin(pi/2-(i-1)*beta); 0];
end

z0 = zeros(n*params.E,1);
for i = 1:params.E
    from = find(params.Bfull(:,i)==-1);
    to = find(params.Bfull(:,i)==1);
    z0(i*n-n+1:i*n) = q0(to*n-n+1:to*n)-q0(from*n-n+1:from*n);
end

t0 = params.tank_size*ones(params.N,1);    % tanks initial condition

initialCondition = [p0; z0; q0; t0];




%