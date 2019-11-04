function new_cycle = post_process_speed(speed,new_cycle)

%% Process the drive cycle to make it mach the mean speed.

if new_cycle.mean_speed ~= 0
    
    factor = speed/new_cycle.mean_speed;
    
    for i = 1:length(new_cycle.speed)
        new_cycle.speed(i,2) =...
            new_cycle.speed(i,2)*factor;
    end
    
    
    % Calculate the final distance and mean speed
    
    new_cycle.mean_speed =...
        mean(new_cycle.speed(:,2))*2.23694; %'mph';
    
    new_cycle.distance =...
        new_cycle.mean_speed*new_cycle.time; %'miles'
    
end

clear i factor

end