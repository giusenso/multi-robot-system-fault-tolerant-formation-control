%% plot data
close all

N = params.N;   % number of robots
E = params.E;   % number of edges
n = size(out.state.Data,2)/(N+E);	% operational space

%% Extract data
s = size(out.q.Data,1);
robot = cell(N,1);
for i = 1:N
    robot{i}.x = (out.q.Data(:,n*(i-1)+1)).';
    robot{i}.y = (out.q.Data(:,n*(i-1)+2)).';
    robot{i}.z = (out.q.Data(:,n*(i-1)+3)).';
end

%% Draw edges
for edge = 1:E
	f = find(params.B(:,edge)==-1);
	t = find(params.B(:,edge)==1);
	line([robot{f}.x(s),robot{t}.x(s)], [robot{f}.y(s),robot{t}.y(s)], [robot{f}.z(s),robot{t}.z(s)], 'Color', 'k')
	hold on;
end

%% Draw robots
color = ['b.';'r.';'r.';'r.'];  % robot colors
for k = 1:N
    plot3(robot{k}.x(s), robot{k}.y(s), robot{k}.z(s), color(k,:),'MarkerSize',30);
	hold on;
end
    set(gca,'XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10,10]);
    grid on; view(-10,60);

clear k i robot


%