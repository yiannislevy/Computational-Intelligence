function plotMap(x_moves, y_moves, x_init, y_init, x_desired, y_desired, theta)
   obstacle_x = [10; 10; 11; 11; 12; 12; 15];
   obstacle_y = [0; -5; -5; -6; -6; -7; -7];

   figure;
   line(x_moves, y_moves, 'Color', 'blue');
   line(obstacle_x, obstacle_y, 'Color', 'black');
   hold on;
   plot(x_init, y_init, 'O');
   hold on;
   plot(x_desired, y_desired, 'X');

   title(['Degrees: ', num2str(theta)]);
end