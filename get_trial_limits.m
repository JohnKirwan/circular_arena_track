 function [trial_limits] = get_trial_limits(landmarks,animal_track)

 num_trials = size(landmarks, 1) / 2; % count number of trials
 trial_limits = zeros([num_trials 11]); % pick out start frame and centre and stimulus coords

 i = 1 ;
 while i <= num_trials % for each trial
 
     trial_limits(i , 1) = landmarks(((i*2)-1),1);       %trial i start frame
     trial_limits(i , 2:3) = landmarks(((i*2)-1),2:3);   %trial i centre point x and y
     trial_limits(i , 4:5) = landmarks(((i*2)),2:3);     %trial i stimulus centre x and y
    
     if i < num_trials
     trial_limits(i , 6) = landmarks(( ((i+1)*2) -1),1) - 1 ;       %trial i last frame
     else
     [j] =  max(animal_track, [], 1);      trial_limits(i , 6) = j(1);
     end
   
     trial_limits(i , 7:8) = (trial_limits(i, 4:5)) - trial_limits(i , 2:3);  
     %normalised stimulus centre in cartesian terms relative to centre of arena

     [theta1 , rho1] = cart2pol(trial_limits(i , 7),trial_limits(i,8)); % polars for stimulus centre
      trial_limits(i , 10) = rho1; % theta in rads, rho in pixels
     
     theta1 = theta1 + (pi/2); % set to conventional degree values with 0 at top and clockwise
     if theta1 < 0;        
         theta1 = theta1 + (pi*2);     
     elseif theta1 > (pi*2);   
         theta1 = theta1 - (pi*2);     
     end
     trial_limits(i , 9) = theta1; 
     
    if (trial_limits(i , 9) >= 0 && trial_limits(i , 9) < pi/4) || (trial_limits(i , 9) > 1.75*pi)         %if stimulus in first quadrant
        trial_limits(i , 11) = 1;
    elseif trial_limits(i , 9) >= (pi/4) && trial_limits(i , 9) < (0.75*pi)
        trial_limits(i , 11) = 2;
    elseif trial_limits(i , 9) >= (0.75*pi) && trial_limits(i , 9) < (1.25*pi)
        trial_limits(i , 11) = 3;
    elseif trial_limits(i , 9) >= (1.25*pi) && trial_limits(i , 9) < (1.75*pi)
        trial_limits(i , 11) = 4;
    end    
     
    i = i + 1 ;
 end
  
  end