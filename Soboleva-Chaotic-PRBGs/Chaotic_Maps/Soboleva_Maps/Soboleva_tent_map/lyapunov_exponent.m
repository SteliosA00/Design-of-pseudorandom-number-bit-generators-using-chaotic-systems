clear; clc; close all;

%% Parameters
a = 1; b = 0.7; c = 1; d = 1;
x0 = 0.2;

%% Soboleva map
smht = @(x) (exp(a*x) - exp(-b*x)) ./ (exp(c*x) + exp(-d*x));
f = @(x,mu) smht(mu * (1 - 2*abs(x - 0.5)));

%% Range of mu values
muVals = linspace(0.1, 4, 400);   % sweep from 0.1 to 4
burn   = 5000;                    % burn-in iterations
N      = 5000;                    % iterations for LE
eps    = 1e-8;                    % step for numerical derivative
LEs    = zeros(size(muVals));     % store Lyapunov exponents

%% Loop over mu
for k = 1:length(muVals)
    mu = muVals(k);
    x = x0;
    
    % burn-in
    for i = 1:burn
        x = f(x,mu);
    end
    
    % accumulate LE
    le_sum = 0;
    for i = 1:N
        fp = (f(x+eps,mu) - f(x-eps,mu)) / (2*eps);
        le_sum = le_sum + log(abs(fp) + 1e-16);
        x = f(x,mu);
    end
    LEs(k) = le_sum / N;
end

%% Plot Lyapunov diagram
figure;
plot(muVals, LEs, 'k','LineWidth',1);
hold on;
yline(0,'r--');
xlabel('\mu');
ylabel('Lyapunov Exponent');
title('Lyapunov Diagram for Soboleva–Tent Map');
grid on;
