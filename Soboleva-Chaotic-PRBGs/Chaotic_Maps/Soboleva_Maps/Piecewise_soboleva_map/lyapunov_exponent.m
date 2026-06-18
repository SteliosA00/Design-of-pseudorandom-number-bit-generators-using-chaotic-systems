% ------------------------------------------------------------
% Lyapunov diagram for the chaotic PRBG based on the SMHT tanh map
% ------------------------------------------------------------
clear; clc; close all;

%% Parameters (Soboleva parameters)
a = 1.4; 
b1 = 1.6; 
c = 0.8; 
d = 0.6;
b = 1;          % symmetry control: 0 = even, 1 = odd
x0 = 0.1;       % initial condition

%% Define SMHT piecewise map
smht = @(x) (exp(a*x) - exp(-b1*x)) ./ (exp(c*x) + exp(-d*x));
smhtMap = @(x, r, b) smhtMap_fn(x, r, b, a, b1, c, d);

%% Range of r values 
rVals = linspace(0.1, 2.5, 400);
burn   = 2000;     % burn-in iterations
N      = 4000;     % iterations for Lyapunov exponent
eps    = 1e-8;     % perturbation for numerical derivative
LEs    = zeros(size(rVals));

%% Main loop
for k = 1:length(rVals)
    r = rVals(k);
    x = x0;

    % Burn-in phase to remove transients
    for i = 1:burn
        x = smhtMap(x, r, b);
    end

    % Lyapunov exponent computation
    le_sum = 0;
    for i = 1:N
        fx_plus  = smhtMap(x + eps, r, b);
        fx_minus = smhtMap(x - eps, r, b);
        fp = (fx_plus - fx_minus) / (2 * eps);
        le_sum = le_sum + log(abs(fp) + 1e-16);
        x = smhtMap(x, r, b);
    end
    LEs(k) = le_sum / N;
end

%% Plot Lyapunov diagram
figure;
plot(rVals, LEs, 'k', 'LineWidth', 1);
hold on;
yline(0, 'r--');
xlabel('r (control parameter)');
ylabel('Lyapunov Exponent');
title('Lyapunov Diagram for Soboleva Piecewise Map');
grid on;
xlim([min(rVals) max(rVals)]);
xticks(0:0.5:2.5);

%% ------------------------------------------------------------
%% SMHT piecewise map 
function fx = smhtMap_fn(x, r, b, a, b1, c, d)
    smht = @(x) (exp(a*x) - exp(-b1*x)) ./ (exp(c*x) + exp(-d*x));
    e = 2 / smht(r);

    if x < 0
        fx = e * smht(r * (x + 1)) - 1;
    else
        fx = (-1)^b * (e * smht(-r * (x - 1)) - 1);
    end
end
