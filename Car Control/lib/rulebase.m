%% Clear Workspace, command window and close all windows
clc
clear 
close all 

%% Create Initial Fuzzy Variables and their Membership Functions
var_names = ["dv" "dh" "theta" "dtheta"];
mf_names = ["S" "M" "L" ; "N" "ZE" "P"];
boundaries = [0 0 0.5 1 1 ; 0 0 0.5 1 1 ; -180 -180 0 180 180 ; -130 -130 0 130 130];

fis = mamfis;
fis.ImplicationMethod = 'prod';

fis = addOutput(fis, [boundaries(end,1) boundaries(end,5)], "Name", var_names(end));
for i=1:length(var_names)-1
    fis = addInput(fis, [boundaries(i,1), boundaries(i,5)], "Name", var_names(i));
end

for i=1:length(var_names)
    for j=1:length(mf_names(1,:))
        fis = addMF(fis, var_names(i), "trimf", [boundaries(i,j) boundaries(i,j+1) boundaries(i,j+2)], "Name", mf_names(ceil(i/2),j));
    end
end

% Αρχική Βάση Κανόνων
% % Για dV = S
% fis = addrule(fis, [1 1 1 3 1 1]);      
% fis = addrule(fis, [1 1 2 3 1 1]);
% fis = addrule(fis, [1 1 3 2 1 1]);
% fis = addrule(fis, [1 2 1 3 1 1]);
% fis = addrule(fis, [1 2 2 3 1 1]);
% fis = addrule(fis, [1 2 3 2 1 1]);
% fis = addrule(fis, [1 3 1 3 1 1]);
% fis = addrule(fis, [1 3 2 2 1 1]);
% fis = addrule(fis, [1 3 3 1 1 1]);
% % Για dV = M
% fis = addrule(fis, [2 1 1 3 1 1]); 
% fis = addrule(fis, [2 1 2 3 1 1]); 
% fis = addrule(fis, [2 1 3 2 1 1]); 
% fis = addrule(fis, [2 2 1 3 1 1]); 
% fis = addrule(fis, [2 2 2 3 1 1]); 
% fis = addrule(fis, [2 2 3 2 1 1]); 
% fis = addrule(fis, [2 3 1 3 1 1]); 
% fis = addrule(fis, [2 3 2 2 1 1]);
% fis = addrule(fis, [2 3 3 1 1 1]); 
% % Για dV = L
% fis = addrule(fis, [3 1 1 3 1 1]); 
% fis = addrule(fis, [3 1 2 3 1 1]); 
% fis = addrule(fis, [3 1 3 2 1 1]); 
% fis = addrule(fis, [3 2 1 3 1 1]); 
% fis = addrule(fis, [3 2 2 3 1 1]);
% fis = addrule(fis, [3 2 3 2 1 1]); 
% fis = addrule(fis, [3 3 1 3 1 1]); 
% fis = addrule(fis, [3 3 2 2 1 1]); 
% fis = addrule(fis, [3 3 3 1 1 1]); 

% Define the rules as an array of antecedent and consequent pairs
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




for i = 1:length(rules)
    fis = addRule(fis, rules{i});
end

writeFIS(fis, 'lib/FLC');
