 function [intersect_pt] = get_track_intersect(circleValues, )

 num_trials = size(circleValues, 1) ;
 %get angle for animal in each trial in radians and put it in animal_angle
animal_radian = zeros([num_trials 1]) ;
correct_intersect = zeros([num_trials 2]) ;
animal_angle = zeros([num_trials 1]) ;

for i = 1:num_trials
    if     which_intersect(i) == 1
        correct_intersect(i,1) = circle_intersect(i,1);
        correct_intersect(i,2) = circle_intersect(i,3);
    elseif which_intersect(i) == 2
        correct_intersect(i,1) = circle_intersect(i,2);
        correct_intersect(i,2) = circle_intersect(i,4);
    else
        error('Error, must be 1 or 2');
    end
    
    %add animals angle relative to stimulus centre to animal_angle
    animal_radian(i) = cart2pol(correct_intersect(i,1),correct_intersect(i,2));
    animal_angle(i) = rad2deg(cart2pol(correct_intersect(i,1),correct_intersect(i,2)));
    
 end
  
 end
 