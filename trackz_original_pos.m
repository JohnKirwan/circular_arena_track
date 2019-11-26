 function [tracks_original_pos] = trackz_original_pos(trackz,trial_limits)

 i = 1  ;   num_trials = size(trial_limits, 1) ; % count number of trials
 pre_tranz_trackz = cell(num_trials, 1) ;
 
    while i <= num_trials ;                     % for each trial / cell array
    j = 1;
    
        while j <= length(trackz{i}) ;           % for each set of coords (row)
        
        pre_tranz_trackz_1{i}(j,1:2) = trackz{i}(j,1:2) - trial_limits(i,2:3) ; %subtract centre coords from x and y coords
        
        [theta , rho] = cart2pol(pre_tranz_trackz_1{i}(j,1),pre_tranz_trackz_1{i}(j,2)) ;
        pre_tranz_trackz_2{i}(j,1:2) = [theta rho] ; %subtract stimulus coords from x and y coords

        tracks_original_pos{i}(j,1) =     pre_tranz_trackz_2{i}(j,1) + pi/2                     ; %ORIGINAL theta
        tracks_original_pos{i}(j,2) =     pre_tranz_trackz_2{i}(j,2) /     trial_limits(i,10)   ; %normalised rho
        
        j = j + 1 ;
        end
 
    i = i + 1;
    end
  
 end