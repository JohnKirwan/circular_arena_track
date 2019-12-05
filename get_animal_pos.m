 function [trackz] = get_animal_pos(trial_limits,animal_track)

 num_trials = size(trial_limits, 1) ; % count number of trials
 i = 1 ;            trackz = cell(num_trials, 1) ;
 
 while i <= num_trials                                        
    % for each set of trial starts
    track_x   = []; track_y   = [] ;   % empty vector for track xs and ys
%   track_x   = [trial_limits(i , 2)]; track_y   = [trial_limits(i , 3)] ;
%   % to include origin
    h = 1; 
     
    while h <= length(animal_track(:,1))                      
    % cycle through the frames
    j   = animal_track(h,1);                                   
    % pick the frame
    
        if j >= trial_limits(i,1) && j <= trial_limits(i,6)       
            % if in the bounds of a given trial
            track_x = [track_x animal_track(h,2)];                
            % append x values for each trial
            track_y = [track_y animal_track(h,3)];                
            % append y values for each trial
        end
        
    h = h + 1       ;    trackz{i} = [track_x' track_y'] ;        %add to cell array for this trial
       
    end     
    i = i + 1       ; 
    
    end      
    end
   
 
    
 
 
 
 
 