function cycle = cherry(modes,targets,m)

% This function first extracts for each target the info about the total
% trip (distance, mean speed and duration) and the info about the highway
% portion (distance ratio and mean speed).
%
% Then it calculates the distance and duration on the highway and the
% distance, duration, and mean speed on city roads.
%
% The function 'dc_city' creates one cycle for each city portion and the
% function 'dc_hwy' creates one cycle for the highway portion.
%
% The drive cycle is finally obtained by concatenating the city cycles and
% the highway cycle.


%% Extract the info
% Distances are in miles, times in hours and speed in mph.

total_distance = targets(m).distance;
total_speed = targets(m).mean_speed;
total_time = targets(m).driving_time;
distance_ratio = targets(m).ratio_hwy; % between 0 and 1
hwy_speed = targets(m).hwy_speed;


%% Compute the inputs for the function 'dc_city' and 'dc_hwy'

dist_hwy = distance_ratio * total_distance;

if dist_hwy ~= 0
    d = total_distance - dist_hwy;
    dist_city_before = (0.1+rand*0.8)*d;
    dist_city_after = total_distance - dist_hwy - dist_city_before;
    hwy_time = dist_hwy/hwy_speed; %'hour'
            
    city_speed = (total_speed*(1-distance_ratio))/(1-distance_ratio/hwy_speed);
    
    time_before = dist_city_before/city_speed; %'hour'
    time_after = dist_city_after/city_speed; %'hour'
end


%% Create the three cycles (one for each portion)

if dist_hwy ~= 0
    [cycle1] = dc_city(modes,dist_city_before,city_speed);
    [cycle2] = dc_hwy(modes,dist_hwy,hwy_speed);
    [cycle3] = dc_city(modes,dist_city_after,city_speed);
else
    [cycle1] = dc_city(modes,total_distance,total_speed);
end

%% Post processing

if dist_hwy ~= 0
    [new_cycle1] = post_process(time_before,city_speed,cycle1);
    [new_cycle2] = post_process(hwy_time,hwy_speed,cycle2);
    [new_cycle3] = post_process(time_after,city_speed,cycle3);
else
    [new_cycle1] = post_process(total_time,total_speed,cycle1);
end


%% Concatenate the cycles into one drive cycle

if dist_hwy ~= 0
    cycle.speed = [new_cycle1.speed;new_cycle2.speed;new_cycle3.speed];
else
    cycle.speed = new_cycle1.speed;
end

cycle.speed(:,1) = (1:length(cycle.speed))';
cycle.speed(:,3) = cycle.speed(:,2)*3.6; %'km/h'


%% Compute the final time, distance and mean speed

t = cycle.speed(:,1); %'seconds'
v = cycle.speed(:,2); % 'm/s'
time = t(end)/3600;         % 'hours'
mean_speed = mean(v)*2.23694;    % 'mph'
distance = mean_speed*time; % 'miles'

cycle.distance = distance;
cycle.time = time;
cycle.mean_speed = mean_speed;

end