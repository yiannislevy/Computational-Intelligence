function initial_fis = initialize_tsk_model(Dtrn, model_config)
    if strcmp(model_config.Type, 'Independent')
        opt_gen = genfisOptions('SubtractiveClustering',... 
                                'ClusterInfluenceRange', model_config.Radius);
        initial_fis = genfis(Dtrn(:, 1:end-1), Dtrn(:, end), opt_gen);
    elseif strcmp(model_config.Type, 'Dependent')
        initial_fis = class_dependent(Dtrn, model_config.Radius, size(Dtrn, 2) - 1, model_config.Part);
    end
end