%% plot data
close all

B = out.B.Data;
N = params.N;   % number of robots
E = params.E;   % number of edges
n = size(out.state.Data,2)/(N+E);	% operational space

%% extract robots data
s = size(out.q.Data,1);
robot = cell(N,1);
for k = 1:N
    robot{k}.x = (out.q.Data(:,n*(k-1)+1)).';
    robot{k}.y = (out.q.Data(:,n*(k-1)+2)).';
    robot{k}.z = (out.q.Data(:,n*(k-1)+3)).';
end

%% Initialize video
set(gcf,'units','points','position',[400,400,600,600])
myVideo = VideoWriter('simulation','MPEG-4'); % open video file
myVideo.FrameRate = 10;  % can adjust this, 5 - 10 works well for me
myVideo.Quality = 100;
open(myVideo)

fault_occurred = 0;
color = {'b.';'r.';'r.';'r.'};  % robot colors
for i = 1:s
    %% Draw edges
    for edge = 1:E
        if(size(find(B(:,edge,i)==1),1) ~= 0)
            f = find(B(:,edge,i)==-1);
            t = find(B(:,edge,i)==1);
            line([robot{f}.x(i),robot{t}.x(i)], [robot{f}.y(i),robot{t}.y(i)], [robot{f}.z(i),robot{t}.z(i)], 'Color','k');
        end
        hold on;
    end
    
    %% Draw robots
    for k = 1:N
        if(sum(abs(B(k,:,i)))==0 && ~fault_occurred)
            fault_occurred = 1;
            color{k} = 'c.';
        end
        plot3(robot{k}.x(i), robot{k}.y(i), robot{k}.z(i), color{k},'MarkerSize',30);
        hold on;
    end
    grid on, view(-10,75);
    set(gca,'XLim',[-10 10],'YLim',[-10 10],'ZLim',[-10,10]);
    pause(0.1)
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
    clf;
end

close(myVideo)
close all
clear myVideo frame



%