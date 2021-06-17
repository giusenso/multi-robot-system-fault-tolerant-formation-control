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

%% Plot
color = ['b.';'r.';'g.';'m.'];
for k = 1:N
    if k<N
        line([robot{k}.x(s),robot{k+1}.x(s)], [robot{k}.y(s),robot{k+1}.y(s)], [robot{k}.z(s),robot{k+1}.z(s)])
    else
        line([robot{k}.x(s),robot{1}.x(s)], [robot{k}.y(s),robot{1}.y(s)], [robot{k}.z(s),robot{1}.z(s)])
    end
    hold on;
end
for k = 1:N
	plot3(robot{k}.x(s), robot{k}.y(s), robot{k}.z(s),color(k,:),'MarkerSize',30);
    set(gca,'XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10,10]);
end
    grid on; view(-10,60);

clear k i robot


%