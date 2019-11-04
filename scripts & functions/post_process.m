function new_cycle = post_process(time,speed,cycle)

%% Post process the drive cycles to make them mach the time first and then the distance and mean speed.

% Make the time match    
new_cycle = post_process_time(time,cycle);

% Make the mean speed match
new_cycle = post_process_speed(speed,new_cycle);

end

