%% plot data
close all

B = out.B.Data;
N = params.N;   % number of robots
E = params.E;   % number of edges
n = size(out.state.Data,2)/(N+E);	% operational space

%% set colors
leader_c = '#EE1111';
follower_c = '#2222FF';
faulted_c = '#9999FF';
trajectory_c = '#006600';
color = cell(1,N);
color{1} = leader_c;
for i = 2:N
    color{i} = follower_c;
end

%% Extract data
robot = cell(N,1);
for i = 1:N
    robot{i}.x = (out.q.Data(:,n*(i-1)+1)).';
    robot{i}.y = (out.q.Data(:,n*(i-1)+2)).';
    robot{i}.z = (out.q.Data(:,n*(i-1)+3)).';
end

%% Draw edges
fault_occurred = 0;
s = size(out.q.Data,1);
for edge = 1:E
    if(size(find(B(:,edge,s)==1),1) ~= 0)
        f = find(B(:,edge,s)==-1);
        t = find(B(:,edge,s)==1);
        line([robot{f}.x(s),robot{t}.x(s)], [robot{f}.y(s),robot{t}.y(s)], [robot{f}.z(s),robot{t}.z(s)], 'Color','#111111');
    end
    hold on;
end

%% Draw robots
for k = 1:N
    if(sum(abs(B(k,:,s)))==0 && ~fault_occurred)
        fault_occurred = 1;
        color{k} = faulted_c;
    end
    plot3(robot{k}.x(s), robot{k}.y(s), robot{k}.z(s),'.','Color',color{k},'MarkerSize',30);
    hold on;
end
%set(gca,'XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10,10]);
grid on; view(0,90);

%% plot tanks
%{
figure('Renderer', 'painters', 'Position', [500 500 1092 800])
for i = 1:N
    t_i = timeseries(out.t.Data(:,i), out.t.Time);
    if (i==4 || i==5)
        plot(t_i, '--', 'linewidth', 2), hold on, grid on;
    else
        plot(t_i, 'linewidth', 2), hold on, grid on;
    end
end
legend('t_1', 't_2', 't_3', 't_4', 't_5');
title('Energy Tanks');
%}

clear k i robot
%