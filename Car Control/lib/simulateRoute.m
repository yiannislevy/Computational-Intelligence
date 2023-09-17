function [x_moves, y_moves, inMap, isClose] = simulateRoute(x_init, y_init, theta, u, x_desired, y_desired, threshold, FLC)
   x = x_init;
   y = y_init;
   x_moves = [];
   y_moves = [];
   inMap = 1; % Variable to check if the car crossed the limits of the map
   isClose = 0;

   while (inMap == 1 && isClose == 0)
       % Calculating Distances
       dv = vertical_distance(x,y);
       dh = horizontal_distance(x,y);
       % Estimating Ouput
       delta_theta = evalfis(FLC, [dv dh theta]);
       theta = theta + delta_theta;
       % Movement
       x = x + u * cosd(theta);
       y = y + u * sind(theta);
       % Check if car is inside the map
       if (x < 0) || (x > 15) || (y > 0) || (y < -8)
           inMap = 0;
       end
       % Update the position
       x_moves = [x_moves; x];
       y_moves = [y_moves; y];

       if (sqrt((abs(x-x_desired))^2 + (abs(y-y_desired))^2) < threshold)
           isClose = 1;
       end
   end
end