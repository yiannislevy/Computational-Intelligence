clc; clear; close all;

% Create Initial Fuzzy Variables and their Membership Functions
var_names = ["dv", "dh", "theta", "dtheta"];

fis = mamfis;
fis.ImplicationMethod = 'prod';

fis = addInput(fis, [0 1], "Name", var_names(1));
fis = addInput(fis, [0 1], "Name", var_names(2));
fis = addInput(fis, [-360 360], "Name", var_names(3));
fis = addOutput(fis, [-150 150], "Name", var_names(4));

%dv
fis = addMF(fis, var_names(1), "trimf", [0 0 0.5], "Name" ,"S");
fis = addMF(fis, var_names(1), "trimf", [0 0.5 1], "Name" ,"M");
fis = addMF(fis, var_names(1), "trimf", [0.5 1 1], "Name" ,"L");

%dh
fis = addMF(fis, var_names(2), "trimf", [0 0 0.5], "Name" ,"S");
fis = addMF(fis, var_names(2), "trimf", [0 0.5 1], "Name" ,"M");
fis = addMF(fis, var_names(2), "trimf", [0.5 1 1], "Name" ,"L");

%theta
fis = addMF(fis, var_names(3), "trapmf", [-360 -180 -120 0], "Name" ,"N");
fis = addMF(fis, var_names(3), "trimf", [-110 0 110], "Name" ,"ZE");
fis = addMF(fis, var_names(3), "trapmf", [0 120 180 360], "Name" ,"P");

%dtheta
fis = addMF(fis, var_names(4), "trapmf", [-150 -120 -50 0], "Name" ,"N");
fis = addMF(fis, var_names(4), "trimf", [-90 0 90], "Name" ,"ZE");
fis = addMF(fis, var_names(4), "trapmf", [0 50 120 150], "Name" ,"P");

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

writeFIS(fis,'lib/flcs/optFLC');
