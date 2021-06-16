%% Formation Control (16.06.21)

clear all
clc

%% System Model ===========================================================

N = 4;	% number of robots
n = 3;	% task space
E = 4;  % number of edges

% incidence matrix
B = [   0	-1	0	1;
        1	0	-1	0; 
        0	1	0  -1;
        -1	0	1   0]

In = sym(eye(n));
IN = sym(eye(N));
q = sym('q',[N*n,1]); assume(q,'real');	% robots positions
p = sym('p',[N*n,1]); assume(p,'real');	% robots momenta
m = sym('m',[N,1]); assume(m,'real');   % robots masses
M = sym(zeros(n*N, n*N));               % inertia matrix
da = sym('da',[N,1]); assume(da,'real');% robots dissipations
Da = sym(zeros(n*N, n*N));              % system dissipation matrix
u = sym('u',[N,1]); assume(u,'real');   % robots inputs
ur = sym('u',[N,1]); assume(ur,'real');	% resistive ports inputs

for i = 1:N
    q_i = sym(strcat('q',num2str(i)),[n,1]); assume(q_i,'real'); 
    q(n*i-n+1: n*i) = q_i;
    
    p_i = sym(strcat('p',num2str(i)),[n,1]); assume(p_i,'real');
    p(n*i-n+1: n*i) = p_i;
    
    M(n*i-n+1:n*i, n*i-n+1:n*i) = eye(n).*m(i);
    Da(n*i-n+1:n*i, n*i-n+1:n*i) = eye(n).*da(i);
    
    u_i = sym(strcat('u',num2str(i)),[n,1]); assume(u_i,'real');
    u(n*i-n+1: n*i) = u_i;
    
    ur_i = sym(strcat('ur',num2str(i)),[n,1]); assume(ur_i,'real');
    ur(n*i-n+1: n*i) = ur_i;
end

% System Hamiltonian
Ha = simplify(0.5*p.'*inv(M)*p)

%% Closed-loop System =====================================================

% closed-loop incidencec matrix    
Bcl = kron(B,In);

z = sym('z',[n*E,1]); assume(z,'real');     % edges lengths
z_des = sym('z_des',[n*E,1]); assume(z_des,'real'); % desired edges lengths
dc = sym('dc',[E,1]); assume(dc,'real');    % robots dissipations
Dc = sym(zeros(n*E, n*E));                  % controller dissipation matrix
kc = sym('kc',[E,1]); assume(kc,'real');    % constant springs
Kc = sym(zeros(n*E, n*E));                  % constant spring matrix
for j = 1:E
	z_j = sym(strcat('z',num2str(j)),[n,1]); assume(z_j,'real');
    z(n*j-n+1: n*j) = z_j;
    
    z_des_j = sym(strcat('z_des',num2str(j)),[n,1]); assume(z_des_j,'real');
    z_des(n*j-n+1: n*j) = z_des_j;
    
    Dc(n*j-n+1:n*j, n*j-n+1:n*j) = eye(n).*dc(j);
    Kc(n*j-n+1:n*j, n*j-n+1:n*j) = eye(n).*kc(j);
end

% Controller Hamiltonian
Hc = 0.5*(z-z_des).'*Kc*(z-z_des)

H = Ha + Hc
H_dot_p = jacobian(H,p).';
H_dot_q = jacobian(H,q).';

p_dot = [-(Da + Bcl*Dc*Bcl.'), -Bcl] * [H_dot_p; H_dot_q]
z_dot = Bcl.' * H_dot_p

state_dot = [p_dot; z_dot];





%