function [error_matrix, OA, PA, UA, kappa] = metrics_evaluation(model, Dchk)
    % Evaluate the model
    y_eval = round(evalfis(model, Dchk(:, 1:end-1)));
    y_orig = Dchk(:, end);
    N = numel(y_orig);

    % Error matrix
    error_matrix = confusionmat(y_orig, y_eval)';
    
    % Overall Accuracy
    OA = sum(diag(error_matrix)) / N;
    
    % Producer's and User's Accuracy
    PA = zeros(1, size(error_matrix, 1));
    UA = zeros(1, size(error_matrix, 1));
    sum_r_c = 0;
    
    for k = 1:size(error_matrix, 1)
        PA(k) = error_matrix(k, k) / sum(error_matrix(:, k));
        UA(k) = error_matrix(k, k) / sum(error_matrix(k, :));
        sum_r_c = sum_r_c + sum(error_matrix(:, k)) * sum(error_matrix(k, :));
    end
    
    % Kappa Coefficient
    kappa = (N * sum(diag(error_matrix)) - sum_r_c) / (N^2 - sum_r_c);
end
