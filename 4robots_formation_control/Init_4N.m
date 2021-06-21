clear all

%% params
T = 30; % running time 

n = 3;  % task space
params.N    = 4;                % number of agents
params.m    = [10;10;10;10];    % masses
params.d    = [10;10;10;10];	% frict. coeff

params.Bfull= [ -1 0 0 +1 -1 0; 
                1 -1 0 0 0 -1;
                0 1 -1 0 1 0;
                0 0 1 -1 0 1];      % full incidence matrix
params.B = [   -1 0 0 +1 0 0;
        1 -1 0 0 0 0;
        0 1 -1 0 0 0;
        0 0 1 -1 0 0];

params.E    = size(params.Bfull,2);	% number of edges
params.dc	= [0;0;0;0;0;0];        % damping coeff
params.kc	= [10;10;10;10;10;10];	% spring constant
d = 10;
params.z_des = [[d;0;0];
                [0;-d;0];
                [-d;0;0];
                [0;d;0];
                [d;-d;0];
                [-d;-d;0]];     % desired edges length

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

q01 = [-2; 2; 0];
q02 = [2; 2; 0];
q03 = [2; -2; 0];
q04 = [-2; -2; 0];
q0 = [q01; q02; q03; q04];

z0 = zeros(n*params.E,1);
for i = 1:params.E
    from = find(params.Bfull(:,i)==-1);
    to = find(params.Bfull(:,i)==1);
    z0(i*n-n+1:i*n) = q0(to*n-n+1:to*n)-q0(from*n-n+1:from*n);
end

initialCondition = [p0; z0; q0];




%
