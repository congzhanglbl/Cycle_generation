% 'realdata' contains the name of the files with driving data from the EPA.
% Each file stores a velocity-time profile in the structure called
% 'sch_cycle'.
%
% The function 'event' extracts the events (acceleration, deceleration,
% cruise and idle) from these profiles.
%
% 'modes' stores the events in their corresponding field (acceleration,
% deceleration, cruise and idle).

realdata = {'fhds1','fuds1','us06','nycc'};

modes = event(realdata);

% Clear the empty fields of 'modes'

k = 1;
while k < length(modes.acceleration)
    if isempty(modes.acceleration(k).segment)
        modes.acceleration(k) = [];
    end
    k = k+1;
end

k = 1;
while k < length(modes.deceleration)
    if isempty(modes.deceleration(k).segment)
        modes.deceleration(k) = [];
    end
    k = k+1;
end

k = 1;
while k < length(modes.cruise)
    if isempty(modes.cruise(k).segment)
        modes.cruise(k) = [];
    end
    k = k+1;
end

k = 1;
while k < length(modes.idle)
    if isempty(modes.idle(k).segment)
        modes.idle(k) = [];
    end
    k = k+1;
end

clear a c d h i ii id acc dec cru idl accel decel cruiz k l n i v w x y z...
    sch_cycle sch_metadata sch_schedule sch_key_on sch_grade cru
clc








