%%% Make file with urchin tracks
%% Read every filename with point_1 and point2

files = dir('D:\sci\PhD\Urchins\Diadema\Tenerife-2016\tracks\');  
files = files.name ;

filez = dir *.txt D:\sci\PhD\Urchins\Diadema\Tenerife-2016\tracks\ ;

cd 'D:\sci\PhD\Urchins\Diadema\Tenerife-2016\tracks\'
filez = ls ;
all_landmarkz = dir *_point01.txt
all_trackz    = dir *_point02.txt

all_filez = dir('D:\sci\PhD\Urchins\Diadema\Tenerife-2016\tracks\') ;
namez     = all_filez(:).name ;



% uigetdir('C:\')
% D:\sci\PhD\Urchins\Diadema\Tenerife-2016\tracks\track_results


%% Run tracking file on each

% Specify file if point_1 not even


% loop through after each set of stimulus locations


% retrieve transformed tracks


% make structure with video name, trial num (in vid)


% derived point order from stimulus locations


% append structure to larger structure


