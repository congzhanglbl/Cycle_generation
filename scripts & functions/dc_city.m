function [cycle] = dc_city(modes,distance,speed)

% Create one city drive cycle.
%
% The drive cycle is created by adding segments of real data one after the
% other until the distance is different from the target by less than 0.1
% mile.
% Each segment is chosen based on the probability matrix and a
% random number.
%
% d_c is the drive cycle being created and is stored in the final structure
% when it's completed. d_c is a matrix with 2 columns: the first column
% contains the time (in this case the step time is one second) and the
% second column contains the speed values (in meters/second).


%% Create the drive cycles

d_c = []; new_segment = []; segment = [];


% Start the drive cycle with an acceleration

i = randi(length(modes.acceleration));

if modes.acceleration(i).segment(1,2) ~= 0
    new_segment(:,2) = modes.acceleration(i).segment(:,2)...
        - modes.acceleration(i).segment(1,2);
else new_segment(:,2) = modes.acceleration(i).segment(:,2);
end

new_segment(new_segment < 0) = 0; % Sets the negative values to zero

% Prevent the drive cycle from starting with a too sharp
% acceleration

for l = 1:length(new_segment)
    if new_segment(l,2) > 15*0.44704 % if instant speed > 15 mph = 15*0.44704 m/s
        cut = 1;
        segment(:,2) = new_segment(1:l,2);
        break
    else cut = 0;
    end
end

if cut == 1
    d_c = [d_c;segment];
else d_c = [d_c;new_segment];
end

segment = []; new_segment = [];


% Calculate the speed,time and distance so far

t = (1:length(d_c))'; % 'seconds'
v = d_c(:,2); % 'meters per second'
t_sf = t(end)*0.000277778; % 'hours'
speed_sf = mean(v)*2.23694; % 'mph'
dist_sf = speed_sf*t_sf; % 'miles'


% The parameter 'iteration' is a security, it stops the while-loop if too long
% (should not happen)
iteration = 1;

while  distance - dist_sf > 0.1
    new_segment = []; event = {};
    
    if iteration == 3000
        break
        
    else err = roundn(speed - speed_sf,-1); % rounds the error value to 1 decimal
        
        % Determine which probability matrix to use according to
        % the state of the vehicle (stopped or driving) and the target
        % speed.
        
        if speed < 5
            a = speed+3; b = speed+5;
            if d_c(end,2) > 8.94 % if the last speed value is greater than 20 mph = 20*0.44704 m/s
                [prob,err_val,b] = city_speed_limit(a+5,b+5);
            elseif d_c(end,2) < 0.5
                [prob,err_val,b] = city_traffic_idle(a,b);
            else
                [prob,err_val,b] = witch(a,b);
            end
        else
            a = speed+5; b = speed+10;
            if d_c(end,2) > 13.41 % if the last speed value is greater than 30 mph = 30*0.44704 m/s
                [prob,err_val,b] = city_speed_limit(a+5,b+5);
            elseif d_c(end,2) < 0.5
                [prob,err_val,b] = city_idle(a,b);
            else [prob,err_val,b] = witch(a,b);
            end
        end
        
        
        % Determine the probability for the next event according to
        % the error value (probability defined by the hat curve)
        
        if err < (-b)
            % the mean speed is higher than the target, we want deceleration
            pi = prob(1,1);
            pa = prob(1,2);
            pc = prob(1,3);
            pd = prob(1,4);
            
        elseif err > b
            % the mean speed is lower than the target, we want acceleration
            pi = prob(end,1);
            pa = prob(end,2);
            pc = prob(end,3);
            pd = prob(end,4);
            
        else
            pi = roundn(prob(roundn(err_val,-1) == err,1),-4);
            pa = roundn(prob(roundn(err_val,-1) == err,2),-4);
            pc = roundn(prob(roundn(err_val,-1) == err,3),-4);
            pd = roundn(prob(roundn(err_val,-1) == err,4),-4);
        end
        
        % Choose the next event with random number + probabilities
        
        n = rand;
        
        if n <= pa
            nn = randi(length(modes.acceleration));
            event = modes.acceleration(nn);
            correction = 1;
            
        elseif n > pa && n <= pa + pc
            nn = randi(length(modes.cruise));
            event = modes.cruise(nn);
            correction = 1;
            
        elseif n > pa + pc && n < pa + pc + pd
            nn = randi(length(modes.deceleration));
            event = modes.deceleration(nn);
            correction = 1;
            
        else
            nn = randi(length(modes.idle));
            event = modes.idle(nn);
            correction = 0;
        end
        
        
        % Extract a random segment from the pool of the chosen event
        % and change the speed so the beginning of the new segment
        % matches the end of the previous one.
        
        k = randi(length(event));
        
        if correction == 1;
            new_segment(:,2) = event(k).segment(:,2) -...
                (event(k).segment(1,2)-d_c(end,2));
        else new_segment(:,2) = event(k).segment(:,2);
        end
        
        new_segment(new_segment < 0) = 0; % Sets the negative values to zero
        d_c = [d_c;new_segment];
        
        t = (1:length(d_c))';
        v = d_c(:,2);
        t_sf = t(end)*0.000277778;
        speed_sf = mean(v)*2.23694;
        dist_sf = speed_sf*t_sf;
        
    end
    
    iteration = iteration +1;
    
end

% End the drive cycle with a deceleration until the speed reaches zero

while d_c(end,2)~=0
    
    new_segment = [];
    
    i = randi(length(modes.deceleration));
    
    new_segment(:,2) = modes.deceleration(i).segment(:,2)...
        -(modes.deceleration(i).segment(1,2)-d_c(end,2));
    
    new_segment(new_segment < 0) = 0;
    d_c = [d_c;new_segment];
    
end


% Compute the final duration of the drive cycle
d_c(:,1) = (1:length(d_c))';

% Calculate the final distance, time and speed

t = (1:length(d_c))';
v = d_c(:,2);
t_sf = t(end)*0.000277778;
speed_sf = mean(v)*2.23694;
dist_sf = speed_sf*t_sf;


cycle.speed = d_c;
cycle.time = t_sf;
cycle.distance = dist_sf;
cycle.mean_speed = speed_sf;


clear b m i k n p pa pc pd iteration p1 p2 t v d_c diff err event...
    t_sf dist_sf speed_sf len_sf new_snippet err_val prob segment

end

