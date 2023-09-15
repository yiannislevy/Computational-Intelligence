    % Initialize and Configure the Linear PI Controller

% Clean up the environment
clc;   % Clear the command window
clearvars; % Clear variables
close all; % Close all figure windows

% Define the system
SystemPoles = [-1, -9];
SystemGain = 10;
Gp = zpk([], SystemPoles, SystemGain); % Plant system

% % Initial PI controller setup
% ControllerZero = -1.3;
% ControllerPole = 0;
% ControllerGain = 1;
% Gc = zpk(ControllerZero, ControllerPole, ControllerGain); % PI Controller

% Use the toolbox to tune the controller

% controlSystemDesigner(Gp, Gc);            

% I saved the session so I dont have to tune it every time, and I load it tuned

load("FinalControlSystemSession.mat");

% Load the parameters of the tuned controller
TunedSession = load("FinalControlSystemSession.mat");
ControllerData = TunedSession.ControlSystemDesignerSession.DesignerData.Designs.Data;
Gc = ControllerData.C % Extract the tuned PI Controller

% Construct the closed loop system
sys_open_loop = Gp * Gc;
sys_closed_loop = feedback(sys_open_loop, 1, -1);

% Plot the step response of the closed-loop system
% figure;
% step(sys_closed_loop);
% title('Step Response of Closed Loop System');
% 
% % Plot the root locus of the open-loop system
% figure;
% rlocus(sys_open_loop);
% title('Root Locus of Open Loop System');

% Compute the proportional and integral gains based on the closed-loop system
ProportionalGainFactor = 10;
ProportionalGain = sys_closed_loop.K / ProportionalGainFactor; % Kp
IntegralGain = -sys_closed_loop.Z{1,1} * ProportionalGain; % Ki


a = ProportionalGain / IntegralGain;
Ki = IntegralGain;
Kp = ProportionalGain;
disp(['Ki: ', num2str(Ki)]);
disp(['Kp: ', num2str(Kp)]);
disp(['a: ', num2str(a)]);


% Obtain step response data
[y, t] = step(sys_closed_loop);

% Calculate step response information
info = stepinfo(y, t);