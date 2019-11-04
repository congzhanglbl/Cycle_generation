% The script 'mode' creates the structure 'modes' which contains
% the modal events extracted from the on-road data: acceleration,
% deceleration, cruise and idle.
%
% The function 'extract_targets' extracts the info from the excel file 'x12dc':
% duration, distance and mean_speed for each target trip.
% Then the script 'hwy_info' adds the distance ratio of highway and the
% mean speed on the highway for each target.
% The function 'do_inputs_make_sense' allows the user to check the accuracy
% of the inputs and the resulting mean speeds and times on highways and
% city roads.
%
% The function 'create_dc' creates the desired number of drive cycles for
% each given target trip.

clear
close all
clc

%% Create the structure of events

mode


%% Create the targets 
   % 'extract_targets' extracts the targets info from the excel file (distance, time and
   % total mean_speed)
   % 'hw_info' adds the highway ratio and mean speed for each target
   % and 'do_inputs_make_sense' displays the resulting distances, times, mean speeds on city roads
   % and highway.

targets = extract_targets('x12dc');

hwy_info

inputs_check = do_inputs_make_sense( targets);


%% Create the drive cycles

% Create the desired number of drive cycles for each targeted trip.
% Each drive cycle is made of 1 highway portion between 2 city road portions.


[drive_cycles] = create_dc(modes,targets);





