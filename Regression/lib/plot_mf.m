function plot_mf(trained_fis, num_features, init)
    figure;
    for i = 1:num_features
        subplot(ceil(sqrt(num_features)), ceil(sqrt(num_features)), i)
        
        % Plot membership function values directly
        [x, mf] = plotmf(trained_fis, 'input', i);
        plot(x, mf);
        
        if init == 1
            title(['Initial MF for Input ', num2str(i)]);
        elseif init == 2
            title(['Final MF for Input ', num2str(i)]);
        end
        ylabel('Membership value');
        xlabel('Input value');
    end
end