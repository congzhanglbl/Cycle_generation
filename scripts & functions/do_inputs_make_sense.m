function [ inputs_check] = do_inputs_make_sense(targets)
% Calculate the  mean speed and times in the city resulting from the 
% distance ratio and highway mean speed given.


%% Extract the info
% Distances are in miles, times in hours and speed in mph.
for m = 1:length(targets)
    total_distance = targets(m).distance;
    total_speed = targets(m).mean_speed;
    distance_ratio = targets(m).ratio_hwy; % between 0 and 1
    hwy_speed = targets(m).hwy_speed;
    
    %% Compute the inputs for the function 'dc_city' and 'dc_hwy'
    % Distances are in miles, time in hour and speed in mph.
    
    dist_hwy = distance_ratio * total_distance;
    
    if dist_hwy ~= 0
        d = total_distance - dist_hwy;
        dist_city_before = rand*0.9*d;
        dist_city_after = total_distance - dist_hwy - dist_city_before;
        hwy_time = dist_hwy/hwy_speed;
        
        city_speed = (total_speed*(1-distance_ratio))/(1-distance_ratio/hwy_speed);
        
        time_city_before = dist_city_before/city_speed;
        time_city_after = dist_city_after/city_speed;
    else hwy_speed = 0;
        hwy_time = 0;
    end
    
    %% Store the distances, times and mean speeds on highway and city roads
    % Distances are in miles, speed are in mph but time are in minutes
    
    inputs_check(m).miles_hwy = dist_hwy;
    inputs_check(m).minutes_on_hwy = hwy_time*60; %'minutes'
    inputs_check(m).hwy_speed = hwy_speed;
    inputs_check(m).miles_city_before = dist_city_before;
    inputs_check(m).minutes_city_before = time_city_before*60; %'minutes'
    inputs_check(m).miles_city_after = dist_city_after;
    inputs_check(m).minutes_city_after = time_city_after*60; %'minutes'
    inputs_check(m).city_speed = city_speed;
    
end

end

