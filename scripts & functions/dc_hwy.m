function [cycle] = dc_hwy(modes,distance,speed)

% Create one highway drive cycle.
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
a = speed+5; b = speed+10;

% Start the drive cycle with an acceleration

i = randi(length(modes.acceleration));

if modes.acceleration(i).segment(1,2) ~= 0
    new_segment(:,2) = modes.acceleration(i).segment(:,2)...
        - modes.acceleration(i).segment(1,2);
else new_segment(:,2) = modes.acceleration(i).segment(:,2);
end

new_segment(new_segment < 0) = 0; % Sets the negative values to zero
d_c = [d_c;new_segment];

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
        
        % Defines the probability matrix to use

            [prob,err_val,b] = highway(a,b);
        
        
        % Determines the probability for the next event according to
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
        
        % Chooses the next event with random number + probabilities
        
        n = rand;
        
        if n <= pa
            nn = randi(length(modes.acceleration));
            event = modes.acceleration(nn);
            cut = 1;
            
        elseif n > pa && n <= pa + pc
            nn = randi(length(modes.cruise));
            event = modes.cruise(nn);
            cut = 0;
            
        elseif n > pa + pc && n < pa + pc + pd
            nn = randi(length(modes.deceleration));
            event = modes.deceleration(nn);
            cut = 2;
        else
            nn = randi(length(modes.idle));
            event = modes.idle(nn);
            cut = 0;
        end
        
        
        % Extracts a random segment from the pool of the chosen event
        % and change the speed so the beginning of the new segment
        % matches the end of the previous one.
        
        k = randi(length(event));
        
        if length(event(k).segment) > 3
            if cut == 1
                if abs(err) < 5
                    new_segment(:,2) = event(k).segment(1:3,2) -...
                        (event(k).segment(1,2)-d_c(end,2));
                else
                    new_segment(:,2) = event(k).segment(:,2) -...
                        (event(k).segment(1,2)-d_c(end,2));
                end
            elseif cut == 2
                new_segment(:,2) = event(k).segment(1:3,2) -...
                    (event(k).segment(1,2)-d_c(end,2));
            else
                new_segment(:,2) = event(k).segment(:,2) -...
                    (event(k).segment(1,2)-d_c(end,2));
            end
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
