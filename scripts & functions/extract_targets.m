function targets = extract_targets(file)

% 'file' is the name of a structure created from an Excel file. It contains
% the trip created with the Monte Carlo sampling method.
% Its fields are Vehicle_ID, State, Start_time, End_time, Distance, P_max
% and Location.
%
% When the State is 'Driving', the function extracts the duration and the
% time and computes the mean speed of the corresponding trip.
% Each target is attributed an ID and stores the info mentioned above.
%
% The output is the structure storing all the targets.

load(file)

k = 0;

for i = 1:length(x12dc)
    match = strcmp(x12dc(i).State,'Driving');
    if match == true
        k = k +1;
        target(k,:) = x12dc(i);
    end
end

% Compute the distance, driving time and mean speed of the trip
for l = 1:length(target)
    targets(l).ID = l;
    targets(l).distance = target(l).Distance;
    targets(l).driving_time = target(l).End_time - target(l).Start_time;
    targets(l).mean_speed = targets(l).distance/targets(l).driving_time;
end

clc

end