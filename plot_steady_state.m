%% plot data
close all

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
color = {'#2222FF';'#FF1111';'#FF1111';'#FF1111'};  % robot colors
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
        color{k} = '#FF8888';
    end
	plot3(robot{k}.x(s), robot{k}.y(s), robot{k}.z(s),'.','Color',color{k},'MarkerSize',35);
	hold on;
end
set(gca,'XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10,10]);
grid on; view(0,90);

clear k i robot


%