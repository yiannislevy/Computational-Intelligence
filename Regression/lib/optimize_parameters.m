function [opt_feature_num, opt_radius, opt_feature_idxs, eval_metrics] = optimize_parameters(data, feature_numbers, radius_a)
    % Feature selection
    [idx, ~] = fsrmrmr(data(:, 1:end-1), data(:, end));

    % Initialize error array
    error = zeros(length(feature_numbers), length(radius_a));
    
    % k-fold cross-validation
    k = 5;
    k_fold = cvpartition(data(:, end), 'KFold', k);

    % Save metrics for future analysis, preallocating space for efficiency

    rmse = zeros(k,1);
    nmse = zeros(k,1);
    ndei = zeros(k,1);
    r2 = zeros(k,1);

    RMSE = zeros(numel(feature_numbers), numel(radius_a));
    NMSE = zeros(numel(feature_numbers), numel(radius_a));
    NDEI = zeros(numel(feature_numbers), numel(radius_a));
    R2 = zeros(numel(feature_numbers), numel(radius_a));
    
    for nf = 1:length(feature_numbers)
        for r = 1:length(radius_a)
            for fold = 1:k_fold.NumTestSets
                % Training and validation data
                trainIdx = k_fold.training(fold);
                valIdx = k_fold.test(fold);
                
                % Reduced feature set
                Dtrn = [data(trainIdx, idx(1:feature_numbers(nf))) data(trainIdx, end)];
                Dval = [data(valIdx, idx(1:feature_numbers(nf))) data(valIdx, end)];
                
                % Initialize and train model
                optFis = genfisOptions('SubtractiveClustering', 'ClusterInfluenceRange', radius_a(r));            
                fis = genfis(Dtrn(:, 1:end-1), Dtrn(:, end), optFis);
                
                optTrain = anfisOptions('InitialFIS', fis, 'EpochNumber', 50, 'DisplayANFISInformation', 0);
                optTrain.ValidationData = Dval;
                optTrain.DisplayANFISInformation = 0;
                optTrain.DisplayErrorValues = 0;
                optTrain.DisplayStepSize = 0;
                optTrain.DisplayFinalResults = 0;
                
                [~, ~, ~, ~, valError] = anfis(Dtrn, optTrain);

                [rmse(fold), nmse(fold), ndei(fold), r2(fold)] = metrics_evaluation(fis, Dval);
                
                % Collect errors
                error(nf, r) = error(nf, r) + mean(valError);
            end
            error(nf, r) = error(nf, r) / k_fold.NumTestSets;
            RMSE(nf,r) = sum(rmse(:))/k;
            NMSE(nf,r) = sum(nmse(:))/k;
            NDEI(nf,r) = sum(ndei(:))/k;
            R2(nf,r) = sum(r2(:))/k;
        end
    end
    
    eval_metrics = [RMSE, NMSE, NDEI, R2];

    % Find the best parameters
    [opt_fn_idx, opt_r_idx] = find(error == min(error(:)));
    opt_feature_num = feature_numbers(opt_fn_idx);
    opt_radius = radius_a(opt_r_idx);
    opt_feature_idxs = idx(1:opt_feature_num);

    % Plotting the errors
    figure;
    [X,Y] = meshgrid(radius_a, feature_numbers);
    surf(X, Y, error);
    xlabel('Radius');
    ylabel('Number of Features');
    zlabel('Validation Error');
    title('Error Surface');

    % Display a table with all combinations and their errors
    all_combinations = [];
    
    for nf = 1:length(feature_numbers)
        for r = 1:length(radius_a)
            all_combinations = [all_combinations; feature_numbers(nf), radius_a(r), error(nf, r)];
        end
    end
    error_table = array2table(all_combinations, 'VariableNames', {'Num_Features', 'Radius', 'ValidationError'});
    disp(error_table);

    % Create an array for the metrics
    metrics_struct = struct('RMSE', [], 'NMSE', [], 'NDEI', [], 'R2', []);
    metrics_array = repmat(metrics_struct, length(feature_numbers), length(radius_a));

    for nf = 1:length(feature_numbers)
        for r = 1:length(radius_a)
            metrics_array(nf, r).RMSE = RMSE(nf, r);
            metrics_array(nf, r).NMSE = NMSE(nf, r);
            metrics_array(nf, r).NDEI = NDEI(nf, r);
            metrics_array(nf, r).R2 = R2(nf, r);
        end
    end

    % Display the evaluation metrics
    fprintf('Metrics for each combination of feature number and radius:\n');
    for nf = 1:length(feature_numbers)
        fprintf('Features: %d\n', feature_numbers(nf));
        for r = 1:length(radius_a)
            fprintf('Radius: %.2f, RMSE: %.4f, NMSE: %.4f, NDEI: %.4f, R2: %.4f\n', ...
                radius_a(r), metrics_array(nf, r).RMSE, metrics_array(nf, r).NMSE, ...
                metrics_array(nf, r).NDEI, metrics_array(nf, r).R2);
        end
        fprintf('\n');
    end
end