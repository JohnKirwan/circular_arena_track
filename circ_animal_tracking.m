%%%%% Get data from animal tracks using dung track
% Uses stimulus centre and point opposite stimulus centre as markers for the 
% unit circle on arena
% Gets complete track from each set of trials, makes a plot and uses 
%Initial Direction Analysis to visualize the initial directions of
% purpuratus relative to stimuli of different size John Kirwan Sep 2015

% You will need CircStat and mapping

%%
proportion_animal_needs_to_go_from_centre_4_a_complete_trial = 0.35;
boks_way = true ;

if boks_way == true
    
    file_folder = strcat(pwd,'\');
    video_name = 'Rnew8203(4)-Y';

    animal_track = importdata(strcat(file_folder,video_name,'_point03.txt')); 
    %tracks of animal throughout trial
    stimulus = importdata(strcat(file_folder,video_name,'_point02.txt')); 
    % stimulus demarcation
    center = importdata(strcat(file_folder,video_name,'_point01.txt')); %origin demarcation
    stimulus = stimulus(1,:);
    center = center(1,:);
    landmarks    = ones( size(center,1)*2, 4); % preallocate landmarks

    if size(stimulus) ~= size(center)
        error('Stimulus and center differ in number of points')
    end
    landmarks = ones( size(center,1)*2, 4); % preallocate landmarks

        for i = 1:size(center,1)
            landmarks(i*2 -1,:) = center(i,:) ;
            landmarks(i*2   ,:) = stimulus(i,:) ;
        end

else
    subfolder = '\circular_arena_track\\';   % or manually
    file_folder = (strcat(pwd,'\\')); % use working directory
    % and the files
    video_name = 'GOPR0210';
    animal_track = importdata(strcat(file_folder,video_name,'_point02.txt')); 
    landmarks = importdata(strcat(file_folder,video_name,'_point01.txt')); 
    % origin and stimulus demarcation
end
    
%%
if mod(size(landmarks, 1),2)  ~= 0           % warning if landmarks uneven
    error('odd number of landmarks') 
end

num_trials = size(landmarks, 1)/2 ;

%%
%find each trial and get data
% (i) frame no (ii - v) coords for centre and stimulus (vi) last frame %
% (vii - viii) normalised stimulus centre (ix) theta in rads (anticlock,
% zero=0) (x) rho in pixels 
trial_limits = get_trial_limits(landmarks, animal_track);

%%
% divide the animal tracks up by trial using the first landmark
trackz = get_animal_pos(trial_limits,animal_track) ;

tranz_trackz = trackz_transform(trackz,trial_limits) ; 
% transform coords to origin and stimulus

% check that the animal leaves the centre of the the arena
goes_away = ones(1,num_trials);
for i = 1:num_trials

furthest_point = max(tranz_trackz{1,i}(:,2));

if furthest_point < proportion_animal_needs_to_go_from_centre_4_a_complete_trial   %% modified from 0.4, was a bit strict
    warning('Animal doesn''t leave centre')
    goes_away(i) = 0;
end
end

%%
% get animal track points closest to rho of 0.25 and 0.5 for each trial
circleValues = zeros([size(trial_limits, 1) 4])    ;

i = 1; 
while i <= size(trial_limits, 1) 

 [~, index] = min(abs(tranz_trackz{i}(:,2) - 0.25))   ;
 circleValues(i,1:2) = tranz_trackz{i}(index, 1:2) ;
 
 [~, index] = min(abs(tranz_trackz{i}(:,2) - 0.5))   ;
 circleValues(i,3:4) = tranz_trackz{i}(index, 1:2) ;
 
 i = i + 1  ;
end

%%   %%
%Create cartesian vector from polar inner and outer circle coordinates 

intersect_angle1 = zeros([num_trials 1]) ;
intersect_angle2 = zeros([num_trials 1]) ;
which_intersect  = zeros([num_trials 1]) ;

% ERRORS occur below if wrong direction

try
for i = 1:num_trials

    [inner_x, inner_y] = pol2cart(circleValues(i,1),circleValues(i,2));
    [outer_x, outer_y] = pol2cart(circleValues(i,3),circleValues(i,4));
    animal_vector(i, 1) = inner_x ;  animal_vector(i, 2) = inner_y ;
    animal_vector(i, 3) = outer_x ;  animal_vector(i, 4) = outer_y ;
    slope(i) = (outer_y - inner_y)/(outer_x - inner_x) ;
    if isnan(slope(i))
        warning('slope is not a number')
    end
    animal_direction(i,1) = outer_x - inner_x;
    animal_direction(i,2) = outer_y - inner_y;
    intercept(i) = animal_direction(i,2) - slope(i) * animal_direction(i,1); %%% JS: This was "- slope(i) * animal_direction(i,2);" but I believe it should be "- slope(i) * animal_direction(i,1);"
    [xout,yout] = linecirc(slope(i),intercept(i),0,0,1) ;
    circle_intersect(i, 1:2) = xout;
    circle_intersect(i, 3:4) = yout; % find x and y points where line intersects with circle

    %get polar coordinates of intersects
    [theta_target1, rho_target1] = cart2pol(circle_intersect(i,1),circle_intersect(i,3))   ;
    [theta_target2, rho_target2] = cart2pol(circle_intersect(i,2),circle_intersect(i,4))   ;
    intersect_angle1(i) = radtodeg(theta_target1) ; 
    intersect_angle2(i) = radtodeg(theta_target2) ;
        
    %%% JS: Instead of the next section being a manual selection, you could
    %%% automatically select the intersect closest the outer crossing 
    dist_to_track(1) = sqrt( (xout(1)-outer_x)^2 + (yout(1)-outer_y)^2 );
    dist_to_track(2) = sqrt( (xout(2)-outer_x)^2 + (yout(2)-outer_y)^2 );
    [~, which_intersect(i)] = min(dist_to_track);
end


%%
%get angle for animal in each trial in degrees and put it in animal_angle
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



catch
    
 animal_radian = NaN;
 if isnan(animal_radian)
     warning('No value for radian')
 end
 
end    

%%
%get the intersect of the tracks with the arena edge
%get_track_intersect(landmarks,animal_track) ;

%%
%create csv output with trial number, position and direction in columns

clear table
table = table('Size',[num_trials 6],'VariableTypes',{
    'string','double','double','double','double','double'});

for i = 1:num_trials
temp_array = {video_name, animal_radian(i)',...
    rad2deg(animal_radian(i)'), goes_away(i),...
    intersect_angle1(i), intersect_angle2(i)};
table(i,1:6) = cell2table(temp_array) ;
end

table.Properties.VariableNames = {
    'Video' 'Radian' 'Degree' 'Moves' 'intersect_angle1' 'intersect_angle2'} ;

% append to previous C
if exist('C', 'var')
    C = vertcat(C, table);
else
    C = table;
end

C.Properties.VariableNames = {
    'Video' 'Radian' 'Degree' 'Moves' 'intersect_angle1' 'intersect_angle2'} ;
writetable(C,'directions_table.txt')




