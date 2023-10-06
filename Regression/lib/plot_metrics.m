function plot_metrics(y_orig, y_eval, trainError, chkError)
    % Number of samples
    N = numel(y_orig);

    % Calculate the residuals
    residuals = y_orig - y_eval;
    
    % Plot Learning Curve
    figure;
    plot([trainError, chkError])
    grid on
    legend('Training Error', 'Validation Error')
    xlabel('Epoch')
    ylabel('Error')
    title('Learning Curve')

    % Plot RMSE
    figure;
    plot(1:N, sqrt(residuals.^2))
    xlabel('Check Data')
    ylabel('Root Mean Square Error (RMSE)')
    title('RMSE')

    % Plot Prediction Error
    figure;
    subplot(2, 1, 1)
    plot([y_orig, y_eval])
    legend('Actual', 'Predicted')
    xlabel('Samples')
    title('Actual vs Predicted')

    subplot(2, 1, 2)
    plot(residuals)
    xlabel('Samples')
    title('Prediction Errors')
end