function [drive_cycles] = create_dc(modes,targets)

%% Create mm cycles for each targeted trip.
% Each drive cycle is made of 1 highway portion between 2 city road portions.


parfor m = 1:length(targets)
    
    for mm = 1:10
        
        cycle = cherry(modes,targets,m);
        
        drive_cycles(m).cycles(mm) = cycle;
        
    end
    
    
end