function [modes] = event1(v)
% Separates the real data into modal events: acceleration, deceleration,
% cruise and idle. Stores them in a structure called mode.
%
% The input v is the vector of the second-by-second speed of the real drive cycles: us06,
% fhds1 & fuds1.
%
% For each speed values (second-by-second), determines which event it belongs to and
% stores it in the corresponding vector: accel, decel, cruiz or idl.
%
% Then separates the continous events of each vector and stores them in
% 'mode' with fields acceleration, deceleration, cruise and idle.
% Each field contains the continuous segments of modal events.


%% Extract the modal events second by second

k = 1;                                         % index of the real data's speed value
accel = []; decel =[]; cruiz = []; idl = [];
a = 0; d = 0; c = 0; id = 0;                   % indexes of the event in the vectors

for n = k:length(v)-2
    
    % if greater than 5mph/s = 2.2352 m/s² or if in 3 seconds, greater than 2mph/s = 0.894 m/s²
    if v(n+1)-v(n) > 2.2352 || v(n+2)-v(n) > 0.894;
        a = a+1;
        accel(a,1) = n;
        accel(a,2) = v(n);
        accel(a+1,1) = n+1;
        accel(a+1,2) = v(n+1);
        
        % idem for deceleration
    elseif v(n+1)-v(n) < -2.2352 || v(n+2)-v(n) < -0.894;
        d = d+1;
        decel(d,1) = n;
        decel(d,2) = v(n);
        decel(d+1,1)= n+1;
        decel(d+1,2) = v(n+1);
        
        % extract idle
    elseif v(n) == 0;
        id = id+1;
        idl(id,1) = n;
        idl(id,2) = 0;
        
        % extract cruise
    else c = c+1;
        cruiz(c,1) = n;
        cruiz(c,2) = v(n);
        
    end
    
end

%% Join the continous events


modes.acceleration = [];  modes.deceleration = [];
modes.cruise = []; modes.idle = [];


acc = []; dec = []; cru = []; id = []; % vectors containing 1 continuous
% event at a time

l = length(modes.acceleration)+1;
k = 3;

for i = 2:length(accel)
    if i == length(accel)
        if ~isempty(acc)
            modes.acceleration(l).segment = acc;
        end
        
    elseif accel(i,1) == accel(i-1,1) +1
        if isempty(acc)   % if acc is empty, accel(i,1) & accel(i-1,1) are
            % the first 2 values of the continuous event
            acc(:,1) = [accel(i-1,1);accel(i,1)];
            acc(:,2) = [accel(i-1,2);accel(i,2)];
            continue
        else acc(k,1) = accel(i,1); % else, it adds the values to the existing event
            acc(k,2) = accel(i,2);
            k = k+1;
            continue
        end
        
    else if ~isempty(acc)    % is empty if the event is shorter than 2 seconds
            modes.acceleration(l).segment = acc;
            l = l+1;
        end
    end
    k = 3;
    acc = [];
    continue
end


l = length(modes.deceleration)+1;
k = 3;
for i = 2:length(decel)
    if i == length(decel)
        modes.deceleration(l).segment = dec;
        
    elseif decel(i,1) == decel(i-1,1) +1
        if isempty(dec)
            dec(:,1) = [decel(i-1,1);decel(i,1)];
            dec(:,2) = [decel(i-1,2);decel(i,2)];
            continue
        else dec(k,1) = decel(i,1);
            dec(k,2) = decel(i,2);
            k = k+1;
            continue
        end
        
    else modes.deceleration(l).segment = dec;
        if ~isempty(modes.deceleration(l).segment)
            l = l+1;
        end
        k = 3;
        dec = [];
        continue
    end
end


l = length(modes.cruise)+1;
k = 3;
for i = 2:length(cruiz)
    if i == length(cruiz)
        modes.cruise(l).segment = cru;
        
    elseif cruiz(i,1) == cruiz(i-1,1) +1
        if isempty(cru)
            cru(:,1) = [cruiz(i-1,1);cruiz(i,1)];
            cru(:,2) = [cruiz(i-1,2);cruiz(i,2)];
            continue
        else cru(k,1) = cruiz(i,1);
            cru(k,2) = cruiz(i,2);
            k = k+1;
            continue
        end
    end
    
    modes.cruise(l).segment = cru;
    if ~isempty(modes.cruise(l).segment)
        l = l+1;
    end
    k = 3;
    cru = [];
    
end


l = length(modes.idle)+1;
k = 3;
if length(idl)>=3
    for i = 2:length(idl)
        if i == length(idl)
            modes.idle(l).segment = id;
            
        elseif idl(i,1) == idl(i-1,1) +1
            if isempty(id)
                id(:,1) = [idl(i-1,1);idl(i,1)];
                id(:,2) = [idl(i-1,2);idl(i,2)];
                continue
            else id(k,1) = idl(i,1);
                id(k,2) = idl(i,2);
                k = k+1;
                continue
            end
        end
        
        modes.idle(l).segment = id;
        if ~isempty(modes.idle(l).segment)
            l = l+1;
        end
        k = 3;
        id = [];
    end
    
end


end