% Extract the events and plots the real data with the colored events

close all
clear
clc

realdata = {'fhds1','fuds1','us06','nycc'};

modes.acceleration = {}; modes.deceleration = {};
modes.cruise = {}; modes.idle = {};

for i = 3:3%length(realdata)
    
    load(realdata{i})
    v = sch_cycle(:,2)*3.6; %'km/h'
    v(end+1:end+2) = 0;
    
    % one_mode is a structure of modal events for one real data drive cycle
    one_mode = event1(v);
    
    % modes contains the modal events of all the real data
    modes.acceleration = [modes.acceleration; one_mode.acceleration];
    modes.deceleration = [modes.deceleration; one_mode.deceleration];
    modes.cruise = [modes.cruise; one_mode.cruise];
    modes.idle = [modes.idle; one_mode.idle];
    
end

% Plot the drive cycles with a different color for each event.

figure
hold all

for w = 1:length(modes.acceleration{1,1})
    plot(modes.acceleration{1, 1}(w).segment(:,1),modes.acceleration{1, 1}(w).segment(:,end),'-.g')
end

for x = 1:length(modes.deceleration{1,1})
    plot(modes.deceleration{1, 1}(x).segment(:,1),modes.deceleration{1, 1}(x).segment(:,end),':r')
end

for y = 1:length(modes.cruise{1,1})
    plot(modes.cruise{1, 1}(y).segment(:,1),modes.cruise{1, 1}(y).segment(:,end),'b')
end

for z = 1:length(modes.idle{1,1})
    plot(modes.idle{1, 1}(z).segment(:,1),modes.idle{1, 1}(z).segment(:,end),'--m')
end

%subplot(length(realdata),1,i)

%     w = streamline({modes.acceleration{i,1}.segment});
%     x = streamline({modes.deceleration{i,1}.segment});
%     y = streamline({modes.cruise{i,1}.segment});
%     z = streamline({modes.idle{i,1}.segment});
%
%     set(w,'Color','green');
%     set(x,'Color','red');
%     set(y,'Color','blue');
%     set(z,'Color','magenta');

%end