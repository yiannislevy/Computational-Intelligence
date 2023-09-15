% Clear command window and close all windows
clc
close all 

% Define input and output variable ranges
boundaries = [-1 -1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1 1];
mf_names = ["NV", "NL", "NM", "NS", "ZR", "PS", "PM", "PL", "PV"];
var_names = ["E", "dE", "dU"];

% Create Mamdani Fuzzy Inference System
fis = mamfis;
fis = addInput(fis, [-1, 1], "Name", var_names(1));
fis = addInput(fis, [-1, 1], "Name", var_names(2));
fis = addOutput(fis, [-1, 1], "Name", var_names(3));

for i = var_names
    for j = 1:1:length(mf_names)
        fis = addMF(fis, i, "trimf", [boundaries(j) boundaries(j+1) boundaries(j+2)], "Name", mf_names(j));
    end
end

% Create Rule Base
rule_weights = [5 4 3 2 1 1 1 1 1];
rule_mapping = [5 6 7 8 9 9 9 9 9];
ruleBase = toeplitz(rule_weights, rule_mapping);

% Convert Rule Base to Strings
ruleBaseStr = strings();  % String representation of the Rule Base
ruleList = [];

for i = 1:length(ruleBase(1,:))
    for j = 1:length(ruleBase(:,1))
        ruleList = [ruleList ; [i j ruleBase(length(ruleBase)+1-i, j) 1 1]];
        ruleBaseStr(i,j) = mf_names(ruleBase(i,j));
    end
end

fis = addRule(fis, ruleList);

% Save the FIS
% writeFIS(fis);
