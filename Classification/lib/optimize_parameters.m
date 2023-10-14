function [opt_feature_num, opt_radius, opt_feature_idxs, eval_metrics] = optimize_parameters(data, feature_numbers, radius_a)
    % Feature selection
    [idx, weight] = fsrmrmr(data(:, 1:end-1), data(:, end));
    
    % Plot the weights of the most significant predictors
    bar(weight(idx));
    ylabel("Weights");
    title("Feature Significance from MRMR Algorithm");

    % k-fold cross-validation
    k = 5;
    k_fold = cvpartition(data(:, end), 'KFold', k, 'Stratify', true); % Stratify ensures balanced classes

    % Preallocate space for new metrics
    OA = zeros(k, 1);
    PA = zeros(k, 5);
    UA = zeros(k, 5);
    KAPPA = zeros(k, 1);

    num_rules = zeros(k, 1);

    % Store the metrics
    OA_all = zeros(numel(feature_numbers), numel(radius_a));
    PA_all = zeros(numel(feature_numbers), numel(radius_a), 5); % todo
    UA_all = zeros(numel(feature_numbers), numel(radius_a), 5); % todo
    KAPPA_all = zeros(numel(feature_numbers), numel(radius_a));
   
    numRules_all = zeros(numel(feature_numbers), numel(radius_a));

    % Grid search
    for nf = 1:length(feature_numbers)
        for r = 1:length(radius_a)
            for fold = 1:k
                % Training and validation data
                trainIdx = k_fold.training(fold);
                valIdx = k_fold.test(fold);
                
                % Reduced feature set
                Dtrn = [data(trainIdx, idx(1:feature_numbers(nf))) data(trainIdx, end)];
                Dval = [data(valIdx, idx(1:feature_numbers(nf))) data(valIdx, end)];

                % Generate class-dependent FIS
                fis = class_dependent(Dtrn, radius_a(r), feature_numbers(nf), 2);

                % Training
                optTrain = anfisOptions('InitialFIS', fis, 'EpochNumber', 50, 'DisplayANFISInformation', 0);
                optTrain.ValidationData = Dval;
                optTrain.DisplayANFISInformation = 0;
                optTrain.DisplayErrorValues = 0;
                optTrain.DisplayStepSize = 0;
                optTrain.DisplayFinalResults = 0;

                fis_trained = anfis(Dtrn, optTrain);
                num_rules(fold) = length(fis_trained.rule);

                % Collect metrics
                [~, OA(fold), PA(fold, :), UA(fold, :), KAPPA(fold)] = metrics_evaluation(fis_trained, Dval, 5);

            end

            % Average metrics
            OA_all(nf, r) = sum(OA) / k;
            PA_all(nf, r, :) = sum(PA, 1) / k;
            UA_all(nf, r, :) = sum(UA, 1) / k;
            KAPPA_all(nf, r) = sum(KAPPA) / k;
            
            numRules_all(nf, r) = sum(num_rules) / k;
        end
    end

    eval_metrics = struct('OA', OA_all, 'PA', PA_all, 'UA', UA_all, 'KAPPA', KAPPA_all);

    % Extract optimal parameters
    [~, max_OA_idx] = max(OA_all(:));
    [opt_fn_idx, opt_r_idx] = ind2sub(size(OA_all), max_OA_idx);
    opt_feature_num = feature_numbers(opt_fn_idx);
    opt_radius = radius_a(opt_r_idx);
    opt_feature_idxs = idx(1:opt_feature_num);
    
    %% Plots

    % OA for all combinations
    figure();
    [X, Y] = meshgrid(feature_numbers, radius_a);
    surf(X, Y, OA_all');
    xlabel('Number of Features');
    ylabel('Cluster Radius');
    zlabel('Overall Accuracy');
    title('Overall Accuracy ft Grid Characteristics');
    
    % OA and NumOfRules
    figure();
    hold on; grid on;
    scatter(reshape(OA_all, 1, []), reshape(numRules_all, 1, []), 'r*');
    xlabel('Overall Accuracy');
    ylabel('Number of Rules');
    title('Overall Accuracy vs Number of Rules');
    hold off;

    % Create an array for the metrics and then display it
    metrics_struct = struct('OA', [],'KAPPA', []);
    metrics_array = repmat(metrics_struct, length(feature_numbers), length(radius_a));

    for nf = 1:length(feature_numbers)
        for r = 1:length(radius_a)
            metrics_array(nf, r).OA = eval_metrics.OA(nf, r);
            metrics_array(nf, r).KAPPA = eval_metrics.KAPPA(nf, r);
        end
    end

    T = table();
    row = 1;
    for nf = 1:length(feature_numbers)
        for r = 1:length(radius_a)
            T.Num_Features(row, 1) = feature_numbers(nf);
            T.Radius(row, 1) = radius_a(r);
            T.OA(row, 1) = metrics_array(nf, r).OA;
            T.KAPPA(row, 1) = metrics_array(nf, r).KAPPA;
            row = row + 1;
        end
    end
    disp(T);

end