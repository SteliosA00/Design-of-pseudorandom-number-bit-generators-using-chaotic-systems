clear; clc; close all;

%% Parameters
a = 1.4; b = 1.6; c = 0.8; d = 0.6;
x0 = 0.1;

%% Soboleva map
smht = @(x) (exp(a*x) - exp(-b*x)) ./ (exp(c*x) + exp(-d*x));
f    = @(x,alpha) rem(alpha * smht(x), 1);

%% Range of alpha values
alphaVals = linspace(0.1, 6, 400);   % sweep range
burn   = 5000; % burn-in iterations
N      = 5000; % iterations for LE
eps    = 1e-8; % step for numerical derivative
LEs    = zeros(size(alphaVals)); % store Lyapunov exponents

%% Loop over alpha
for k = 1:length(alphaVals)
    alpha = alphaVals(k);
    x = x0;
    
    % burn-in
    for i = 1:burn
        x = f(x,alpha);
    end
    
    % accumulate LE
    le_sum = 0;
    for i = 1:N
        fp = (f(x+eps,alpha) - f(x-eps,alpha)) / (2*eps); % numerical derivative
        le_sum = le_sum + log(abs(fp) + 1e-16);
        x = f(x,alpha);
    end
    LEs(k) = le_sum / N;
end

%% Plot Lyapunov diagram
figure;
plot(alphaVals, LEs, 'k','LineWidth',1);
hold on;
yline(0,'r--');
xlabel('\alpha');
ylabel('Lyapunov Exponent');
title('Lyapunov Diagram for Soboleva Chaotic Map');
grid on;

xticks(0:1:6);      
xlim([0 6]);          
