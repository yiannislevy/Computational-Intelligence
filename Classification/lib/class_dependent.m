function fis = class_dependent(Dtrn, model_config)
    
    radius = model_config.Radius;

    if model_config.Part == 1
        fis = sugfis;
        
        % Add Input and Output Variables
        num_features = size(Dtrn, 2) - 1;
        for i = 1:num_features
            name_in = ['in', num2str(i)];
            fis = addInput(fis, [0, 1], 'Name', name_in);
        end
        fis = addOutput(fis, [0, 1], 'Name', 'out1');
        
        % Cluster Data by Class
        [c1, sig1] = subclust(Dtrn(Dtrn(:, end) == 1, :), radius);
        [c2, sig2] = subclust(Dtrn(Dtrn(:, end) == 2, :), radius);
        num_rules = size(c1, 1) + size(c2, 1);
        
        % Add Input Membership Functions
        for i = 1:num_features
            name_in = ['in', num2str(i)];
            for j = 1:size(c1, 1)
                fis = addMF(fis, name_in, 'gaussmf', [sig1(i), c1(j, i)]);
            end
            for j = 1:size(c2, 1)
                fis = addMF(fis, name_in, 'gaussmf', [sig2(i), c2(j, i)]);
            end
        end
        
        % Add Output Membership Functions
        output_params = [zeros(1, size(c1, 1)), ones(1, size(c2, 1))];
        for i = 1:num_rules
            fis = addMF(fis, 'out1', 'constant', output_params(i));
        end
        % output_params = linspace(0, 1, num_rules);
        % for i = 1:num_rules
        %     fis = addMF(fis, 'out1', 'constant', output_params(i));
        % end

        
        % Create Rule Base
        % rule_list = zeros(num_rules, num_features);
        % rule_list = zeros(num_rules, num_features + 1 + 2);  % 1 output variable and 2 additional columns for weight and output type
        % 
        % for i = 1:num_rules
        %     rule_list(i, :) = i;
        % end
        % % rule_list = [rule_list, ones(num_rules, 2)];  % Rule list with weight and output type
        % rule_list(:, end-2:end) = 1;
        % fis = addrule(fis, rule_list);

        ruleList = zeros(num_rules, size(Dtrn,2));
        for i=1:size(ruleList,1)
            ruleList(i,:) = i;
        end
        ruleList = [ruleList, ones(num_rules,2)];
        fis = addrule(fis, ruleList);

            
    elseif model_config.Part == 2
        % Placeholder for part 2 code
    end
end
