% script to plot animal tracks overlaid in matlab
% John Kirwan April 2016

%set corresponding colors
colorVec = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840;
    1 ,1, 0; 1, 0, 1; 0, 1, 1; 1, 0, 0; 0, 1, 0; 0, 0, 1 ] ;
colorVec = [colorVec; colorVec; colorVec; colorVec; colorVec] ;

%%  
% data_folder = uigetdir('M:\'); addpath(data_folder) ;   %bring in the dataset with UI         
subfolder = 'tracks\';     % or manually
file_folder = (strcat('M:\DATA\2016\Tenerife-2016\',subfolder));

%% and the files
video_name = 'GOPR0286';
landmarks = importdata(strcat(file_folder,video_name,'_point01.txt')); %origin and stimulus demarcation
animal_track = importdata(strcat(file_folder,video_name,'_point02.txt')); %tracks of animal throughout trial

% add CircStat to path
addpath('C:/Users/john/Documents/MATLAB/Apps/CircStat/')
addpath('C:/Users/john/Documents/MATLAB/thunderdome/')

if mod(size(landmarks, 1),2)  ~= 0           % warning if landmarks uneven
    error('odd number of landmarks') 
end

num_trials = size(landmarks, 1)/2 ;

% %% add points
% 
% milli_90_bar_II = [-0.041094 -2.9021 1.0691 0.31681];
% milli_90_bar_I = [-0.33584 2.0517 -0.16614 -0.42573] ;
% milli_50_DoG_I = [-0.92938 -2.7237 2.0553 1.6799] ;
% milli_50_DoG_II = [  2.356 -2.6682 -3.0903 -0.061108] ;
% diadema_50_bar_I = [1.6972 -0.39566 0.22 -0.3113] ;
% diadema_50_bar_II = [-0.018943 1.5235 2.4305 0.35023] ;
% diadema_25_DoG_I = [-3.0174 0.1887 2.8635 -1.1139 ];
% diadema_25_DoG_II = [0.76944 -1.4903 0.99494 1.4544] ;
% strongylocentrotus_50_bar_I = [0.39184 -0.96785 -2.9449 0.74954 ] ;
% strongylocentrotus_50_bar_II = [3.106 0.18538 0.51398 1.2656] ;
% strongylocentrotus_35_DoG_I = [0.044601 1.0797 2.3378 0.028386 ] ;
% strongylocentrotus_35_DoG_II = [3.0147 1.3939 1.7001 -1.1199 ] ;
% 
% points = strongylocentrotus_35_DoG_II ;

%%
%find each trial and get data
% (i) frame no (ii - v) coords for centre and stimulus (vi) last frame %
% (vii - viii) normalised stimulus centre (ix) theta in rads (anticlock.
% zero=0) (x) rho in pixels 
trial_limits = get_trial_limits(landmarks, animal_track);

%%
% divide the animal tracks up by trial using the first landmark
trackz = get_animal_pos(trial_limits,animal_track) ;
tracks_original_pos = trackz_original_pos(trackz,trial_limits) ; % transform coords to origin and stimulus

%% create single plot with many trials and points marked
figure;
counter = 1 ; %
% nums = [1:4] ;%[1 3:5];

for j = 1:length(tracks_original_pos)

% for j = nums
plot_a_track(tracks_original_pos, j, colorVec, counter)
counter = counter + 1 ;
end

title(strcat(video_name,' original track orientations')) ;
labels = ['1'; ' '; '2'; ' '; '3'; ' '; '4'];
legend(labels);

%% put points on the circle to mark direction vectors used

% cart_points = zeros([length(points) 2]);
% % 
% for k = 1:length(points)
%     points(k) = -(points(k) - pi/2) ;  % set to clockwise and zero at 0
%     [x, y] = pol2cart(points(k),1) ;    %  back to cartesian
%     cart_points(k, 1) = x         ;
%     cart_points(k,2) = y          ;
% end
% 
% for m = 1:length(cart_points)                   % plot the points as markers on the circle perimeter
%     plot(cart_points(m,1),cart_points(m,2),'o',...
%         'MarkerFaceColor',colorVec(m,1:3),...
%         'MarkerEdgeColor',colorVec(m,1:3)) ;
% end
% 
% hold off ;

%% add points for midpoints of stimuli 
cart_stim_mids = zeros([length(trial_limits(:,9)) 2]);

for k = 1:length(trial_limits(:,9))
    trial_limits(k,9) = -(trial_limits(k,9)) ;  % set to clockwise and zero at 0
    [x, y] = pol2cart(trial_limits(k,9),1) ;    %  back to cartesian
    cart_stim_mids(k, 1) = x         ;
    cart_stim_mids(k,2) = y          ;
end

for m = 1:length(cart_stim_mids)                   % plot the points as markers on the circle perimeter
    plot(cart_stim_mids(m,1),cart_stim_mids(m,2),'o',...
        'MarkerFaceColor',colorVec(m,1:3),...
        'MarkerEdgeColor',colorVec(m,1:3)) ;
end

hold off ;

%%
