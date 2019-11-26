% simple plots of testing

while i <= 4
     plot(trial_limits(i,7),trial_limits(i,8),'r+')
     % Label the points with the corresponding 'x' value
     text(trial_limits(i,7),trial_limits(i,8),num2str(i));
     hold;
     i = i + 1;
end

