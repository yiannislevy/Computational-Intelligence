function [Dtrn, Dval, Dchk] = split_data(data)    
    % Randomize the rows
    idx = randperm(size(data, 1));
    data = data(idx, :);
    
    % Normalize to unit hypercube
    xmin = min(data(:, 1:end-1), [], 1);
    xmax = max(data(:, 1:end-1), [], 1);
    data(:, 1:end-1) = (data(:, 1:end-1) - xmin) ./ (xmax - xmin);
    
    % Split Data
    n = size(data, 1);
    Dtrn = data(1:round(n * 0.6), :);
    Dval = data(round(n * 0.6) + 1:round(n * 0.8), :);
    Dchk = data(round(n * 0.8) + 1:end, :);
    
    % Display Sizes
    disp('Dimensions of Training Data:');
    disp(size(Dtrn));
    disp('Dimensions of Validation Data:');
    disp(size(Dval));
    disp('Dimensions of Checking Data:');
    disp(size(Dchk));
end