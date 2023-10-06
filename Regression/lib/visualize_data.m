function visualize_data(data, feature_names, selected_indices)
    % If feature_names is empty, generate generic names
    if isempty(feature_names)
        feature_names = arrayfun(@(x) ['Feature' num2str(x)], 1:size(data,2)-1, 'UniformOutput', false);
    end
    
    % Data Visualization
    num_features = length(selected_indices);  % Using only selected features

    for i = 1:num_features
        subplot(ceil(sqrt(num_features + 1)), ceil(sqrt(num_features + 1)), i)
        scatter(1:length(data(:, selected_indices(i))), data(:, selected_indices(i)), 'MarkerEdgeAlpha', .6)
        xlabel('Data Point')
        ylabel(feature_names{selected_indices(i)})
        title([feature_names{selected_indices(i)} ' Scatter Plot'])
    end

    % Plotting the output (last column)
    subplot(ceil(sqrt(num_features + 1)), ceil(sqrt(num_features + 1)), num_features + 1)
    scatter(1:length(data(:, end)), data(:, end), 'MarkerEdgeAlpha', .6)
    xlabel('Data Point')
    ylabel('Output')
    title('Output Scatter Plot')
    
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
end