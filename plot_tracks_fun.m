function [results_matrix] = plot_tracks_fun(file_folder,video_name,colorVec)


%%and the files
%video_name fed from plot_tracks_on_speed
landmarks = importdata(strcat(file_folder,video_name,'_point01.txt')); %origin and stimulus demarcation
animal_track = importdata(strcat(file_folder,video_name,'_point02.txt')); %tracks of animal throughout trial

if mod(size(landmarks, 1),2)  ~= 0           % warning if landmarks uneven
    error('odd number of landmarks') 
end
num_trials = size(landmarks, 1)/2 ;

results_matrix = zeros([num_trials 7]);     %pre-assign output

%% %find each trial and get data
% (i) frame no (ii - v) coords for centre and stimulus (vi) last frame %
% (vii - viii) normalised stimulus centre (ix) theta in rads (clockwise.
% zero=top) (x) rho in pixels 
trial_limits = get_trial_limits(landmarks, animal_track);

%% % divide the animal tracks up by trial using the first landmark
trackz = get_animal_pos(trial_limits,animal_track) ;
tranz_trackz = trackz_transform(trackz,trial_limits) ; % transform coords to origin and stimulus
tracks_original_pos = trackz_original_pos(trackz,trial_limits) ; % transform coords to origin and stimulus

%% % get animal track points closest to rho of 0.25 for each trial
circleValues = zeros([size(trial_limits, 1) 4])    ;

i = 1;
while i <= size(trial_limits, 1)       % for each track
    
    if min(tranz_trackz{i}(:,2)) >= 0.25                    % if the lowest rho value for the tracks is above 0.25 
        [~, index] = min(tranz_trackz{i}(:,2))            ; 
        circleValues(i,1:2) = tranz_trackz{i}(index, 1:2) ;% make this the first heading value
        warntext = ['For ',num2str(video_name),' track ',num2str(i),', no track closer than 0.25; first point with rho of ',...
            num2str(tranz_trackz{i}(index, 2)),' used'];
        warning(warntext)
    elseif min(tranz_trackz{i}(:,2)) > 0.5;                    % if the lowest rho value for the tracks is above 0.5
         warntext = ['For ',num2str(video_name),' track ',num2str(i),', no track closer than 0.5; first point with rho of ',...
            num2str(tranz_trackz{i}(index, 2)),' used - SHOULD ABORT'];
        warning(warntext)
    else
    j = 1 ;
        
    while j <= length(tranz_trackz{i}(:,2))        %for each point in the track
        if tranz_trackz{i}(j,2) <= 0.25 && tranz_trackz{i}(j+1,2) <= 0.5            
            % if the point is less than a quarter radius from the origin
            % and the next point is less than 0.5 radii
             circleValues(i,1:2) = tranz_trackz{i}(j+1,1:2) ;  %update the first heading value to be the point after this
        elseif tranz_trackz{i}(j,2) <= 0.25 && tranz_trackz{i}(j+1,2) > 0.5
             circleValues(i,1:2) = tranz_trackz{i}(j,1:2) ;  %if no points between 0.25 and 0.5, use the last point before
        end   
    j = j + 1 ;
    end 
    end
    i = i + 1 ;
end

%% get animal track points closest to rho of 0.5 for each trial
i = 1;
while i <= size(trial_limits, 1)       % for each track
    
        if max(tranz_trackz{i}(:,2)) <= 0.5                    % if the lowest rho value for the tracks is above 0.5 
        [~, index] = max(tranz_trackz{i}(:,2))            ; 
        circleValues(i,3:4) = tranz_trackz{i}(index, 1:2) ;% make this the second heading value
        warntext = ['For ',num2str(video_name),' track ',num2str(i),', no track further than 0.5; last point with rho of ',...
            num2str(tranz_trackz{i}(index, 2)),' used'];
        warning(warntext)
        else
    j = 1 ;
    while j <= length(tranz_trackz{i}(:,2))        %for each point in the track
        if tranz_trackz{i}(j,2) <= 0.5  && j == length(tranz_trackz{i}(:,2))         % if the point is less than a half radius from the origin
             circleValues(i,3:4) = tranz_trackz{i}(j,1:2);                           %update the first heading value to be the same point
        elseif tranz_trackz{i}(j,2) <= 0.5
             circleValues(i,3:4) = tranz_trackz{i}(j+1,1:2);                       %update the first heading value to be the point after this
        end   
    j = j + 1 ;
    end 
        end
 
 i = i + 1 ; 
end

%% get animal track points closest to rho of 0.75 as estimate of place of destination
destinations = zeros([size(trial_limits, 1) 2])    ;

i = 1;
while i <= size(trial_limits, 1) ;

 [~, index] = min(abs(tranz_trackz{i}(:,2) - 0.75))   ;
 destinations(i,1:2) = tranz_trackz{i}(index, 1:2) ;
 
    if destinations(i,1) < 0;       destinations(i,1) = destinations(i,1) + pi*2;           end 
 
 i = i + 1  ;
end

%%   %%
%Create cartesian vector from polar inner and outer circle coordinates 

intersect_angle1 = zeros([num_trials 1]) ;      intersect_angle2 = zeros([num_trials 1]) ;
which_intersect  = zeros([num_trials 1]) ;      
animal_direction = zeros([num_trials 2]) ;      circle_intersect    = zeros([num_trials 4]) ;

%%%JS: The next section was a bit hard to follow, so I cleaned it up a bit

for i = 1:num_trials

    [inner_x, inner_y] = pol2cart(circleValues(i,1),circleValues(i,2));
    [outer_x, outer_y] = pol2cart(circleValues(i,3),circleValues(i,4));
%   animal_vector(i, 1) = inner_x ;  animal_vector(i, 2) = inner_y ;
%   animal_vector(i, 3) = outer_x ;  animal_vector(i, 4) = outer_y ;
%   slope(i) = (outer_y - inner_y)/(outer_x - inner_x) ;
    animal_direction(i,1) = outer_x - inner_x;
    animal_direction(i,2) = outer_y - inner_y;
    slope(i) = animal_direction(i,2) / animal_direction(i,1) ;
    intercept(i) = animal_direction(i,2) - slope(i) * animal_direction(i,1); %%% JS: This was "- slope(i) * animal_direction(i,2);" but I believe it should be "- slope(i) * animal_direction(i,1);"
    [xout,yout] = linecirc(slope(i),intercept(i),0,0,1) ;
    circle_intersect(i, 1:2) = xout;
    circle_intersect(i, 3:4) = yout; % find x and y points where line intersects with circle

    %get polar coordinates of intersects
    [theta_target1, ~] = cart2pol(circle_intersect(i,1),circle_intersect(i,3))   ;
    [theta_target2, ~] = cart2pol(circle_intersect(i,2),circle_intersect(i,4))   ;
    intersect_angle1(i) = rad2deg(theta_target1) ; 
    intersect_angle2(i) = rad2deg(theta_target2) ;
    
    %%% JS: Instead of the next section being a manual selection, you could
    %%% automatically select the intersect that is closest to the outer circle
    %%% crossing, e.g. like this:
    dist_to_track(1) = sqrt( (xout(1)-outer_x)^2 + (yout(1)-outer_y)^2 );
    dist_to_track(2) = sqrt( (xout(2)-outer_x)^2 + (yout(2)-outer_y)^2 );
    [~, which_intersect(i)] = min(dist_to_track);

end
 
%%
%get angle for animal in each trial in degrees and put it in animal_angle
% animal_radian = zeros([num_trials 1]) ;
correct_intersect = zeros([num_trials 2]) ;
% animal_angle = zeros([num_trials 1]) ;

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
%     animal_radian(i) = cart2pol(correct_intersect(i,1),correct_intersect(i,2));
%     animal_angle(i) = rad2deg(cart2pol(correct_intersect(i,1),correct_intersect(i,2)));
      results_matrix(i,1) = cart2pol(correct_intersect(i,1),correct_intersect(i,2));               %heading in radians
    
    if results_matrix(i,1) < 0
        results_matrix(i,1) = results_matrix(i,1) + pi*2;
    elseif results_matrix(i,1) >= pi*2 
        results_matrix(i,1) = results_matrix(i,1) - pi*2;
    end
    
end
     
%%
results_matrix(:,2) = rad2deg(results_matrix(:,1)) ;     %heading in degrees
results_matrix(:,3) = destinations(:,1);                 %heading at edge (0.75 radii)
results_matrix(:,4) = circleValues(:,2);                 % rho of first vector value
results_matrix(:,5) = circleValues(:,4);                 % rho of second vector value
results_matrix(:,6) = trial_limits(:,9);                 % original heading of stimulus in relation to the camera
results_matrix(:,7) = trial_limits(:,11);                % position of stimulus from 1 to 4

%% create single plot with many trials and points marked
trails_plot = figure();   set(trails_plot, 'Visible', 'off');
counter = 1 ; %
% nums = [1:4] ;%[1 3:5];

for j = 1:num_trials

% for j = nums
plot_a_track(tranz_trackz, j, colorVec, counter)
counter = counter + 1 ;
end

if length(tranz_trackz) <= 4
    labels = ['1'; ' '; '2'; ' '; '3'; ' '; '4';];
else
    labels = ['1'; ' '; '2'; ' '; '3'; ' '; '4'; ' '; '5'; ' '; '6'; ' '; '7'; ' '; '8'];
end

title(video_name) ;

%% add points calculated

calc_points = zeros([num_trials 2]);    k = 1;

while k <= num_trials 
    calc_points(k) = -(results_matrix(k,1)) + (pi/2) ;  % set to radian convention to be clockwise and zero at 0
    [x, y] = pol2cart(calc_points(k),1) ;    %  back to cartesian
    calc_points(k, 1) = x         ;
    calc_points(k,2) = y          ;

    plot(calc_points(k,1),calc_points(k,2),'o',...      % plot the points as markers on the circle perimeter
        'MarkerFaceColor',colorVec(k,1:3),...
        'MarkerEdgeColor',colorVec(k,1:3)) ;
    
k = k + 1;
end

legend(labels);
p = strcat(video_name,'_stim_at_top');
print(p,'-depsc');
close(trails_plot);

%% create single plot with many trials and points marked for original points
orig_plot = figure();   set(orig_plot, 'Visible', 'off');       counter = 1 ; %

    for j = 1:length(tracks_original_pos)
        plot_a_track(tracks_original_pos, j, colorVec, counter)
        counter = counter + 1 ;
    end

title(strcat(video_name,' original track orientations')) ;

%% add points for midpoints of stimuli 
cart_stim_mids = zeros([length(trial_limits(:,9)) 2]);
pol_stim_mids = zeros([length(trial_limits(:,9)) 1]);           k = 1;

while k <= num_trials
    pol_stim_mids(k) = -(trial_limits(k,9)) + pi/2 ;  % set to radian convention to be clockwise and zero at 0
    [x, y] = pol2cart(pol_stim_mids(k),1) ;    %  back to cartesian
    cart_stim_mids(k, 1) = x         ;
    cart_stim_mids(k,2) = y          ;
    
    plot(cart_stim_mids(k,1),cart_stim_mids(k,2),'h',...    % plot the points as markers on the circle perimeter
   'MarkerFaceColor',colorVec(k,1:3),...
   'MarkerEdgeColor',colorVec(k,1:3)) ;
    k = k + 1;
    
end

legend(labels);
p = strcat(video_name,'_orig_track');
print(p,'-depsc');
close(orig_plot)

end

