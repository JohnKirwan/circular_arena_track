% plot_tracks_on_speed
% script to plot animal tracks overlaid in matlab
% John Kirwan April 2016

%% set corresponding colors
colorVec = [0, 0.4470, 0.7410; 0.8500, 0.3250, 0.0980; 0.9290, 0.6940, 0.1250;
    0.4940, 0.1840, 0.5560; 0.4660, 0.6740, 0.1880; 0.3010, 0.7450, 0.9330; 0.6350, 0.0780, 0.1840;
    1 ,1, 0; 1, 0, 1; 0, 1, 1; 1, 0, 0; 0, 1, 0; 0, 0, 1 ] ;
colorVec = [colorVec; colorVec; colorVec; colorVec; colorVec] ;

%% % pick the source folder and get names

file_folder = (strcat(pwd,'\')); % get all text files from the working directory
cd(file_folder)

landmark_files = dir('*_point01.txt');
track_files = dir('*_point02.txt');

    if length(landmark_files) ~= length(track_files)
        warning('Number of landmarks and tracks not matching');
    end



%% make the output csv file here
% mkdir(file_folder,'track_results');                      %make folder for output file
results = [];  file = [];  i = 1;

while i <= length(landmark_files) % take data from successive files and feed as matrices to tracking function

video_name = regexprep(landmark_files(i).name,'_point01.txt','');   %extract video names from the landmark files
[output] = plot_tracks_fun(file_folder,video_name,colorVec); % get the data from the file
results = [results; output]; % append this data into a spreadsheet with the filename
C = cell(size(output,1),1); C(:) = {video_name} ;
file = [file; C];                                 % make into list of all filenames

i = i + 1;
end

theta = results(:,1);                %heading angle in radians
degrees = results(:,2);              %heading angle in degrees
destination = results(:,3);          %heading of animal at 0.75 of radius from centre
rho1 = results(:,4);                 %rho value of first vector point
rho2 = results(:,5);                 %rho value of second point
stimulus = results(:,6);             %theta of stimulus position in video
stimpos = results(:,7);              %number of stimulus position in video

T = table(file,theta,degrees,destination,rho1,rho2,stimulus,stimpos);
writetable(T,'headings.csv','WriteRowNames',true)

%%
% add section to include stimulus heading in output
