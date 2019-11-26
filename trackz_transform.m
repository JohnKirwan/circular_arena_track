 function [tranz_trackz] = trackz_transform(trackz,trial_limits)

 i = 1  ;   num_trials = size(trial_limits, 1) ; % count number of trials
 pre_tranz_trackz = cell(num_trials, 1) ;
 
    while i <= num_trials ;                     % for each trial / cell array
    j = 1;
    
        while j <= length(trackz{i}) ;           % for each set of coords (row)
        
        pre_tranz_trackz_1{i}(j,1:2) = trackz{i}(j,1:2) - trial_limits(i,2:3) ; %subtract centre coords from x and y coords
        
        [theta , rho] = cart2pol(pre_tranz_trackz_1{i}(j,1),pre_tranz_trackz_1{i}(j,2)) ;
        pre_tranz_trackz_2{i}(j,1:2) = [theta rho] ; %subtract stimulus coords from x and y coords

        tranz_trackz{i}(j,1) =     (pre_tranz_trackz_2{i}(j,1) + (pi/2)) -     trial_limits(i,9)    ; %normalised theta
        tranz_trackz{i}(j,2) =      pre_tranz_trackz_2{i}(j,2) /     trial_limits(i,10)   ; %normalised rho
        
        if  tranz_trackz{i}(j,1) < (-2*pi)
            tranz_trackz{i}(j,1) = tranz_trackz{i}(j,1) + (4*pi);
        elseif tranz_trackz{i}(j,1) < 0
            tranz_trackz{i}(j,1) = tranz_trackz{i}(j,1) + (2*pi);
        end
             
        j = j + 1 ;
        end
 
    i = i + 1;
    end
  
 end
 
 
 
 