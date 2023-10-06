function [trained_fis, training_info] = train_tsk_model(initial_fis, Dtrn, Dval, num_epochs)
    % Configure ANFIS options
    opt_an = anfisOptions('InitialFIS', initial_fis, 'EpochNumber', num_epochs);
        
    opt_an.ValidationData = Dval;
    opt_an.OptimizationMethod = 1;  % 1 = hybrid method

    % Disable output information
    opt_an.DisplayANFISInformation = 0;
    opt_an.DisplayErrorValues = 0;
    opt_an.DisplayStepSize = 0;
    opt_an.DisplayFinalResults = 0;

    % Train the model
    [trained_fis, trainError, ~, ~, chkError] = anfis(Dtrn, opt_an);

    % Return training and checking errors for later use
    training_info = struct();
    training_info.trainError = trainError;
    training_info.chkError = chkError;
    training_info.epochNumber = opt_an.EpochNumber;
end