function new_cycle = post_process_time(time,cycle)

%% Process the drive cycle to make it mach the target time.

target_time = time*3600; %'seconds'

speed = cycle.speed(:,2); %'m/s'
delta = round(length(speed) - target_time); %'seconds'

iteration = 1;

if delta > 0 % the drive cycle is longer than the target
    
    while delta > 0
        
        iteration = iteration +1;
        
        if iteration > 500
            break
        end
        
        if delta < length(speed)
            a = round(length(speed) - delta);
        else a = round(length(speed));
        end
        
        n = randi(a);
        
        if n + delta >= length(speed)
            end_loop = length(speed);
        else
            end_loop = n+delta;
        end
        
        for k = n+1:end_loop
            if abs(speed(k) - speed(n)) < 1
                speed(n:k) = [];
                break
            end
        end
        
        delta = round(length(speed) - target_time);
        
    end
    
    new_speed = speed;
    
elseif delta < 0 % the drive cycle is shorter than the target
    
    new_speed = speed;
    
    while delta < 0
        
        iteration = iteration +1;
        
        if iteration > 500
            break
        end
        
        if abs(delta) < length(new_speed)
            aa = round(length(new_speed) + delta);
        else aa = round(length(new_speed))-1;
        end
        
        n = randi(aa);
        
        before(:,1) = new_speed(1:n);
        after(:,1) = new_speed(n+1:end);
        
        if delta < (-10)
            nn = randi(10); % 10 is the maximum block of time that can be
            % added to keep the drive cycle realistic
        else
            nn = randi(abs(delta));
        end
        
        
        if n + nn > length(new_speed)
            end_loop = length(new_speed);
        else end_loop = nn;
        end
        
        for l = 1:nn
            if l == 1
                new_segment(l,1) = (new_speed(n)+new_speed(n+1))/2;
            else
                new_segment(l,1) = (new_segment(l-1,1)+new_speed(n+1))/2;
            end
        end
        
        new_speed = [before;new_segment;after];
        before = []; after = []; new_segment = [];
        
        delta = round(length(new_speed) - target_time);
        
    end
    
else
    new_speed = speed;
end

final_speed(:,1) = (1:length(new_speed))';
final_speed(:,2) = new_speed;

new_cycle.speed = final_speed; %'m/s'
new_cycle.time = length(final_speed)*0.000277778; %'hours'
new_cycle.mean_speed = mean(new_speed)*2.23694; %'mph'
new_cycle.distance =...
    new_cycle.mean_speed*new_cycle.time; %'miles'


clear a aa b i ii k l delta dist_rq speed_rq t_rq target_time...
    final_speed new_speed end_loop new_segment before after

end


