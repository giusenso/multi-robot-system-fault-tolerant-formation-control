%% plot data
close all

N = params.N;   % number of robots
E = params.E;   % number of edges
n = size(out.state.Data,2)/(N+E);	% operational space

%% extract data
num_samples = size(out.q.Data,1);
robot = cell(N,1);
for i = 1:N
    robot{i}.x = (out.q.Data(:,n*(i-1)+1)).'
    robot{i}.y = (out.q.Data(:,n*(i-1)+2)).'
    robot{i}.z = (out.q.Data(:,n*(i-1)+3)).'
end

%% Initialize video
myVideo = VideoWriter('simulation','MPEG-4'); % open video file
myVideo.FrameRate = 10;  % can adjust this, 5 - 10 works well for me
myVideo.Quality = 100;
open(myVideo)

%% draw robot positions
for i = 1:num_samples
    for k = 1:N
        plot3(robot{k}.x(i), robot{k}.y(i), robot{k}.z(i),'r.','MarkerSize',30);
        hold on, grid on, view(-10,60);
    end
    set(gca,'XLim',[-15 15],'YLim',[-15 15],'ZLim',[-15,15]);
    pause(0.1)
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
    clf;
end

close(myVideo)


%