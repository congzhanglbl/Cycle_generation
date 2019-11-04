function modes = event(realdata)

% This function separates the real data into modal events -acceleration,
% deceleration, cruise and idle- and stores them in a structure called mode.
%
% 'realdata' contains the name of the driving data files from the EPA.
%
% 'v' is the vector of the second-by-second speed stored in the
% structure 'sch_cycle'.
%
% The function first determines for each speed value the corresponding
% event and stores it in the corresponding vector: accel, decel, cruiz or idl.
%
% Then it separates the continous events in each vector and stores them in
% 'mode' with fields acceleration, deceleration, cruise and idle.
% Each field contains the continuous segments of the corresponding event.


modes.acceleration = {}; modes.deceleration = {};
modes.cruise = {}; modes.idle = {};

for h = 1:length(realdata)
    
    load(realdata{h})
    v = sch_cycle(:,2);
    v(end+1:end+2) = 0;
    
    %% Extract the modal events second by second
    
    k = 1;                                         % index of the real data speed value
    accel = []; decel =[]; cruiz = []; idl = [];
    a = 0; d = 0; c = 0; id = 0;                   % indexes of the event in the corresponding vectors
    % a is the row index of the acceleration vector, d for deceleration, c for cruise
    % and id for idle.
    
    for n = k:length(v)-2
        
        % Extract acceleration
        % if greater than 3 mph/s = 3*0.44704 m/s² = 1.34112 m/s²
        if v(n+1)-v(n) > 1.34112
            a = a+1;
            accel(a,1) = n;
            accel(a,2) = v(n);
            accel(a+1,1) = n+1;
            accel(a+1,2) = v(n+1);
         
        % or if in 3 seconds, greater than 1 mph/s = 0.44704 m/s²
        elseif v(n+2)-v(n) > 0.44704
            a = a+1;
            accel(a,1) = n;
            accel(a,2) = v(n);
            accel(a+1,1) = n+1;
            accel(a+1,2) = v(n+1);
            accel(d+2,1)= n+2;
            accel(d+2,2) = v(n+2);
            
        % Extract deceleration    
        % idem for deceleration
        elseif v(n+1)-v(n) < -1.34112
            d = d+1;
            decel(d,1) = n;
            decel(d,2) = v(n);
            decel(d+1,1)= n+1;
            decel(d+1,2) = v(n+1);
            
        elseif v(n+2)-v(n) < -0.44704
            d = d+1;
            decel(d,1) = n;
            decel(d,2) = v(n);
            decel(d+1,1)= n+1;
            decel(d+1,2) = v(n+1);
            decel(d+2,1)= n+2;
            decel(d+2,2) = v(n+2);
            
            
        % Extract idle
        elseif v(n) == 0;
            id = id+1;
            idl(id,1) = n;
            idl(id,2) = 0;
            
        % Extract cruise
        else c = c+1;
            cruiz(c,1) = n;
            cruiz(c,2) = v(n);
            
        end
        
    end
    
    %% Join the continous events
    
    if h ==1
        modes.acceleration = [];  modes.deceleration = [];
        modes.cruise = []; modes.idle = [];
    end
    
    acc = []; dec = []; cru = []; id = []; % vectors containing 1 continuous event at a time
    
    l = length(modes.acceleration)+1;
    k = 3;
    
    for i = 2:length(accel)
        if i == length(accel)
            if ~isempty(acc)
                modes.acceleration(l).segment = acc;
            end
            
        elseif accel(i,1) == accel(i-1,1) +1
            if isempty(acc)                   % if acc is empty, accel(i,1) & accel(i-1,1) are
                                                % the first 2 values of the continuous event
                acc(:,1) = [accel(i-1,1);accel(i,1)];
                acc(:,2) = [accel(i-1,2);accel(i,2)];
                continue
            else acc(k,1) = accel(i,1);       % else, it adds the values to the existing event
                acc(k,2) = accel(i,2);
                k = k+1;
                continue
            end
            
        else if ~isempty(acc)                 % is empty if the event is shorter than 2 seconds
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
            
        else
            if ~isempty(dec)
                dec(end+1,1) = decel(i-1,1);
            end
            modes.deceleration(l).segment = dec;
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