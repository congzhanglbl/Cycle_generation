% This script adds 2 fields to the structure 'targets': ratio_hwy and
% hwy_speed.
%
% 'ratio_hwy' is the distance ratio of highway in the total trip. It is
% between 0.3 and 0.9 if the mean speed of the total trip is lower than 40
% mph, and between 0.7 and 0.9 if the total mean speed is greater than 40
% mph. It equals 0 if the total mean speed is lower than 10 mph.
%
% 'hwy_speed' is the mean_speed on this highway portion. It is between the
% 35 and 45 mph if the mean speed of the total trip is lower than 40 mph,
% and between 45 mph and 55 mph if the total mean speed is greater than 40
% mph.


%% Add the highway distance ratio

for i = 1:length(targets)
    if targets(i).mean_speed < 10
        targets(i).ratio_hwy = 0;
    elseif targets(i).mean_speed < 40
        targets(i).ratio_hwy = 0.30 + 0.60*rand;
    else targets(i).ratio_hwy = 0.70 + 0.20*rand;
    end
end

%% Add the mean speed on highway

for ii = 1:length(targets)
    if targets(ii).ratio_hwy ~= 0
        if targets(ii).mean_speed < 40
            targets(ii).hwy_speed = 35 + 10*rand;
        else
            targets(ii).hwy_speed = 45 + 10*rand;
        end    
    else targets(ii).hwy_speed = 0;
    end
end

clear i ii

