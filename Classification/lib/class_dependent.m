function fis = class_dependent(Dtrn, radius, num_features, part)
    if part == 1
        fis = sugfis;
        
        % Add Input and Output Variables
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

        % Add FIS Rule Base
        ruleList = zeros(num_rules, size(Dtrn,2));
        for i=1:size(ruleList,1)
            ruleList(i,:) = i;
        end
        ruleList = [ruleList, ones(num_rules,2)];
        fis = addrule(fis, ruleList);
            
    elseif part == 2
        fis = sugfis;

        % Add Input and Output Variables
        for i = 1:num_features
            name_in = ['in', num2str(i)];
            % min_bound = min(Dtrn(:, i));
            % max_bound = max(Dtrn(:, i));
            fis = addInput(fis, [0, 1], 'Name', name_in);
        end
        fis = addOutput(fis, [1, 5], 'Name', 'out1');

        % Placeholder for different classes
        classes = unique(Dtrn(:, end));
        params = [];
        idx = 1;

       % Loop through each class to add Membership Functions
        for c = classes'
            [centers, sigmas] = subclust(Dtrn(Dtrn(:, end) == c, :), radius);
            for i = 1:num_features
                name_in = ['in', num2str(i)];
                for j = 1:size(centers, 1)
                    fis = addMF(fis, name_in, 'gaussmf', [sigmas(i), centers(j, i)]);
                end
            end
        
            params = [params, c * ones(1, size(centers, 1))];
            idx = idx + size(centers, 1);
        end
        
        % Add Output Membership Functions
        for i = 1:idx - 1
            fis = addMF(fis, 'out1', 'constant', params(i));
        end

        % Add FIS Rule Base
        ruleList = zeros(idx - 1, num_features + 1);
        for i = 1:size(ruleList, 1)
            ruleList(i, :) = i;
        end
        ruleList = [ruleList, ones(idx - 1, 2)];
        fis = addrule(fis, ruleList);  
        
    end
end
