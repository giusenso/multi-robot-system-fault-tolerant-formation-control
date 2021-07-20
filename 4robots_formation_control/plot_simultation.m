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

%% extract robots data
robot = cell(N,1);
for k = 1:N
    robot{k}.x = (out.q.Data(:,n*(k-1)+1)).';
    robot{k}.y = (out.q.Data(:,n*(k-1)+2)).';
    robot{k}.z = (out.q.Data(:,n*(k-1)+3)).';
end

%% Initialize video
set(gcf,'units','points','position',[400,400,600,600])
myVideo = VideoWriter('simulations/simulation','MPEG-4'); % open video file
myVideo.FrameRate = 10;  % can adjust this, 5 - 10 works well for me
myVideo.Quality = 100;
open(myVideo)

fault_occurred = 0;
s = size(out.q.Data,1);

%% check steady state time instant

for i = 1:s
    exit_flag = 0;
    for k = 1:N
        if( i>100 && norm([robot{k}.x(i)-robot{k}.x(i-2); robot{k}.y(i)-robot{k}.y(i-2); robot{k}.z(i)-robot{k}.z(i-2)]) < 0.001 )
            exit_flag = exit_flag + 1;  % robot is no moving anymore
        end
    end
    if(exit_flag==N)
        s = i;
        break;
    end
end



for i = 1:s
    %% Draw edges
    for edge = 1:E
        if(size(find(B(:,edge,i)==1),1) ~= 0)
            f = find(B(:,edge,i)==-1);
            t = find(B(:,edge,i)==1);
            line([robot{f}.x(i),robot{t}.x(i)], [robot{f}.y(i),robot{t}.y(i)], [robot{f}.z(i),robot{t}.z(i)], 'Color','#111111');
        end
        hold on;
    end
    
    %% Draw trajectory
    plot3(out.y1.Data(:,1),out.y1.Data(:,2),out.y1.Data(:,3))
    
    %% Draw robots
    for k = 1:N
        if(sum(abs(B(k,:,i)))==0 && ~fault_occurred)
            fault_occurred = 1;
            color{k} = faulted_c;
        end
        plot3(robot{k}.x(i), robot{k}.y(i), robot{k}.z(i),'.','Color',color{k},'MarkerSize',35);
        hold on;
        
        % check if robot at steady state
        if ( i>100 && norm([robot{k}.x(i)-robot{k}.x(i-2); robot{k}.y(i)-robot{k}.y(i-2); robot{k}.z(i)-robot{k}.z(i-2)]) < 0.1 )
            exit_flag = exit_flag + 1;  % robot is no moving anymore
        end
    end
      
    grid on, view(-10,60);
    set(gca,'XLim',[-180 180],'YLim',[-180 180],'ZLim',[0,100]);
    pause(0.1)
    frame = getframe(gcf); %get frame
    writeVideo(myVideo, frame);
    clf;

end

close(myVideo)
close all
clear myVideo frame



%