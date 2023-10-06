function initial_fis = initialize_tsk_model(Dtrn, model_config)
    if strcmp(model_config.Part, '1')
        % Configuration for part 1
        opt_gen = genfisOptions('GridPartition',... 
                                'NumMembershipFunctions', model_config.NumMFs,... 
                                'InputMembershipFunctionType', model_config.InputMFT,... 
                                'OutputMembershipFunctionType', model_config.OutputMFT);
        initial_fis = genfis(Dtrn(:, 1:5), Dtrn(:, 6), opt_gen);
    elseif strcmp(model_config.Part, '2')
        % Configuration for part 2
        opt_gen = genfisOptions('SubtractiveClustering',... 
                                'ClusterInfluenceRange', model_config.Radius);
        initial_fis = genfis(Dtrn(:, 1:model_config.NumFeatures), Dtrn(:, end), opt_gen);
    end
end