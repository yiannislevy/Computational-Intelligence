function [error_matrix, OA, PA, UA, kappa] = metrics_evaluation(model, Dchk, num_classes)
    % Evaluate the model
    y_eval = round(evalfis(model, Dchk(:, 1:end-1)));
    y_eval(y_eval < 1) = 1;
    y_eval(y_eval > 5) = 5;

    y_orig = Dchk(:, end);
    N = numel(y_orig);

    % Error matrix
    error_matrix = confusionmat(y_orig, y_eval)';
    
    % Pad the error matrix for missing classes
    if size(error_matrix, 1) < num_classes || size(error_matrix, 2) < num_classes
        padded_error_matrix = zeros(num_classes);
        padded_error_matrix(1:size(error_matrix, 1), 1:size(error_matrix, 2)) = error_matrix;
        error_matrix = padded_error_matrix;
    end
    
    % Overall Accuracy
    OA = sum(diag(error_matrix)) / N;
    
    % Producer's and User's Accuracy
    PA = zeros(1, num_classes);
    UA = zeros(1, num_classes);

    for k = 1:num_classes
        if sum(error_matrix(:, k)) ~= 0
            PA(k) = error_matrix(k, k) / sum(error_matrix(:, k));
        else
            PA(k) = NaN;
        end
        
        if sum(error_matrix(k, :)) ~= 0
            UA(k) = error_matrix(k, k) / sum(error_matrix(k, :));
        else
            UA(k) = NaN;
        end
    end
    
    % Kappa Coefficient
    sum_r_c = sum(sum(error_matrix, 2) .* sum(error_matrix, 1));
    kappa = (N * sum(diag(error_matrix)) - sum_r_c) / (N^2 - sum_r_c);
end