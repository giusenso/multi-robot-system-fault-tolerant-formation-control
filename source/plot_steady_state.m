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

x_min=robot{1}.x(1); y_min=robot{1}.y(1); z_min=robot{1}.z(1);
x_max=robot{1}.x(1); y_max=robot{1}.y(1); z_max=robot{1}.z(1);
for k = 1:N
    if(max(robot{k}.x) > x_max)
        x_max = max(robot{k}.x)*1.1+1;
    end
    if(min(robot{k}.x) < x_min)
        x_min = min(robot{k}.x)*1.1-1;
    end
    if(max(robot{k}.y) > y_max)
        y_max = max(robot{k}.y)*1.1+1;
    end
    if(min(robot{k}.y) < y_min)
        y_min = min(robot{k}.y)*1.1-1;
    end
	if(max(robot{k}.z) > z_max)
        z_max = max(robot{k}.z)*1.1+1;
    end
    if(min(robot{k}.z) < z_min)
        z_min = min(robot{k}.z)*1.1;
    end
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

diff = (x_max-x_min) - (y_max-y_min);
if(diff>=0)  
    y_min = y_min-(diff)/2;
    y_max = y_max+(diff)/2;
else
	x_min = x_min+(diff)/2;
    x_max = x_max-(diff)/2;
end  
set(gca,'XLim',[x_min, x_max],'YLim',[y_min, y_max], 'ZLim',[z_min, z_max+1]);
grid on; view(0,90);

%% plot tanks
figure()
for i = 1:N
    t_i = timeseries(out.t.Data(:,i), out.t.Time);
    plot(t_i, 'linewidth', 2), hold on, grid on;
end
legend('t_1', 't_2', 't_3', 't_4', 't_5');
title('Energy Tanks');

clear k i robot
%