function plot_a_track(tranz_trackz,trial_num, colorVec, counter)
% function to plot all the points marked for a given trial

    a = cell2mat(tranz_trackz(trial_num)) ;         %get trial data
    b = zeros(length(a),2)                ;

    %figure;
    
    for h = 1:length(a) ;                           %turn polar coords to 0 deg and clockwise
        a(h,1) = -(a(h,1) - pi/2) ;       
    end
    
    for i = 1:length(a) ;                           %back into carteisan coords in matrix b
        
        if a(i,2) > 1                               % keep tracks inside the circle
            a(i,2) = 1 ;
        end
        
    [x, y] = pol2cart(a(i,1),a(i,2)) ;
    b(i,1) = x ;
    b(i,2) = y ;
    end

    plot(b(:,1),b(:,2), ':',...                     % plot the points with colours corresponding to the tracks
        'MarkerFaceColor',colorVec(counter,1:3),...
        'MarkerEdgeColor',colorVec(counter,1:3),...
        'Color',colorVec(counter,1:3),...
        'LineWidth',3) ;

    
    hold on                                         % draw a circle
    th = 0:pi/50:2*pi;
    xunit = 1 * cos(th) ;
    yunit = 1 * sin(th) ;
    plot(xunit, yunit,...
        'Color','k',...
        'LineWidth',2);
    
    axis([-1.1 1.1 -1.1 1.1])
    axis equal
%     ax = gca;
%     ax.XAxisLocation = 'origin';
%     ax.YAxisLocation = 'origin';
    axis off
    hold on
    
    
end
