%% plot data
close all

% set colors
leader_c = '#FF1111';
robot_c = '#2222FF';
faulted_c = '#8888EE';
color = {leader_c, robot_c, robot_c, robot_c};  % robot colors

B = out.B.Data;
N = params.N;   % number of robots
E = params.E;   % number of edges
n = size(out.state.Data,2)/(N+E);	% operational space

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
	plot3(robot{k}.x(s), robot{k}.y(s), robot{k}.z(s),'.','Color',color{k},'MarkerSize',35);
	hold on;
end
%set(gca,'XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10,10]);
grid on; view(0,90);


%% plot dissipated energy
figure();
for i = 1:N
    t_i = timeseries(out.t.Data(:,i), out.t.Time);
    if (i==3 || i==4)
        plot(t_i, '--', 'linewidth', 1.5), hold on, grid on;
    else
        plot(t_i, 'linewidth', 1.5), hold on, grid on;
    end
end
legend('t_1', 't_2', 't_3', 't_4');
title('Energy Tanks');

%% plot edges
%{
figure();
norm_z = cell(E,1);
for i = 1:E
    zzz = zeros(size(out.state.Time));
    for t = 1:size(out.state.Time, 1)
        if (sum(abs(B(:,i,t)))~=0)
            zzz(t) = norm(out.state.Data(t, N*n+n*(i-1)+1:N*n+n*i));
            time(t) = t;
        end
    end
    norm_z{i} =  timeseries(zzz, time);
    
    if (i==2 || i==4)
        plot(norm_z{i}, '--','linewidth', 1.5); hold on; grid on;
    else
        plot(norm_z{i}, 'linewidth', 1.5); hold on; grid on;
    end
end
legend('z_1', 'z_2', 'z_3', 'z_4', 'z_5', 'z_6');
title('Edge distances');
%}



clear k i robot


%