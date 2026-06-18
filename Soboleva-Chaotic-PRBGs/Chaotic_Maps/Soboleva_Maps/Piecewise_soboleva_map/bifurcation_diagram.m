% ------------------------------------------------------------
% Bifurcation diagram for the chaotic PRBG based on SMHT piecewise map
% ------------------------------------------------------------
clear; clc; close all;

%% Parameters 
a  = 1.4;
b1 = 1.6;
c  = 0.8;
d  = 0.6;
b  = 1;           % symmetry control: 0 = even, 1 = odd
x0 = 0.1;         % initial condition

%% Define the SMHT piecewise map 
smht = @(x) (exp(a*x) - exp(-b1*x)) ./ (exp(c*x) + exp(-d*x));
smhtMap = @(x, r, b) smhtMap_fn(x, r, b, a, b1, c, d);

%% Range of r values 
rVals = linspace(0.1, 2.5, 600);

%% Iteration settings
totalIter = 3000;   % total iterations per r
lastIter  = 300;    % points to keep for plotting

%% Storage for plotting
points_r = [];
points_x = [];

%% Loop over r values
for r = rVals
    x = x0;

    % burn-in phase
    for i = 1:(totalIter - lastIter)
        x = smhtMap(x, r, b);
    end

    % collect last points
    for i = 1:lastIter
        x = smhtMap(x, r, b);
        points_r(end+1) = r; 
        points_x(end+1) = x;
    end
end

%% Plot bifurcation diagram
figure;
plot(points_r, points_x, '.k', 'MarkerSize', 1);
xlabel('r (control parameter)');
ylabel('x');
title('Bifurcation Diagram for Soboleva Piecewise Map');
grid on;
xlim([min(rVals) max(rVals)]);
xticks(0:0.5:2.5);

%% ------------------------------------------------------------
%% SMHT tanh map function
function fx = smhtMap_fn(x, r, b, a, b1, c, d)
    smht = @(x) (exp(a*x) - exp(-b1*x)) ./ (exp(c*x) + exp(-d*x));
    e = 2 / smht(r); 

    if x < 0
        fx = e * smht(r * (x + 1)) - 1;
    else
        fx = (-1)^b * (e * smht(-r * (x - 1)) - 1);
    end
end
