function [RMSE, NMSE, NDEI, R2] = metrics_evaluation(model, Dchk)
    % Evaluate the model
    y_eval = evalfis(model, Dchk(:, 1:end-1));
    y_orig = Dchk(:, end);

    % Calculate the residuals
    residuals = y_orig - y_eval;

    % Calculate total sum of squares
    SStot = sum((y_orig - mean(y_orig)).^2);

    % Calculate residual sum of squares
    SSres = sum(residuals.^2);

    % Number of samples
    N = numel(y_orig);

    % RMSE
    RMSE = sqrt(SSres / N);

    % NMSE
    NMSE = SSres / SStot;

    % NDEI
    NDEI = sqrt(NMSE);

    % R2
    R2 = 1 - (SSres / SStot);
end