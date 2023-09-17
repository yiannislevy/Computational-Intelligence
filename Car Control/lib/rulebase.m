clc; clear; close all;

% Create Initial Fuzzy Variables and their Membership Functions
var_names = ["dv" "dh" "theta" "dtheta"];
mf_names = ["S" "M" "L" ; "N" "ZE" "P"];
boundaries = [-0.5 0 0.5 1 1.5 ; -0.5 0 0.5 1 1.5 ; -360 -180 0 180 360 ; -260 -130 0 130 260];

fis = mamfis;
fis.ImplicationMethod = 'prod';

fis = addInput(fis, [0 1], "Name", var_names(1));
fis = addInput(fis, [0 1], "Name", var_names(2));
fis = addInput(fis, [-180 180], "Name", var_names(3));
fis = addOutput(fis, [-130 130], "Name", "dtheta");

for i = 1:length(var_names)
    for j = 1:length(mf_names(1,:))
        fis = addMF(fis, var_names(i), "trimf", [boundaries(i,j) boundaries(i,j+1) boundaries(i,j+2)], "Name", mf_names(ceil(i/2),j));
    end
end

rules = {
    [1 1 1 2 1 1],
    [1 1 2 1 1 1],
    [1 1 3 1 1 1],
    [1 2 1 2 1 1],
    [1 2 2 2 1 1],
    [1 2 3 1 1 1],
    [1 3 1 3 1 1],
    [1 3 2 2 1 1],
    [1 3 3 1 1 1],
    [2 1 1 2 1 1],
    [2 1 2 1 1 1],
    [2 1 3 1 1 1],
    [2 2 1 3 1 1],
    [2 2 2 2 1 1],
    [2 2 3 1 1 1],
    [2 3 1 3 1 1],
    [2 3 2 2 1 1],
    [2 3 3 1 1 1],
    [3 1 1 2 1 1],
    [3 1 2 1 1 1],
    [3 1 3 1 1 1],
    [3 2 1 2 1 1],
    [3 2 2 2 1 1],
    [3 2 3 1 1 1],
    [3 3 1 3 1 1],
    [3 3 2 2 1 1],
    [3 3 3 1 1 1]
};

% Add rules
for i = 1:length(rules)
    fis = addRule(fis, rules{i});
end

writeFIS(fis,'lib/flcs/FLC');
