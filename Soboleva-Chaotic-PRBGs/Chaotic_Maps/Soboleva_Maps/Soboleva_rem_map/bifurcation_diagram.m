clear; clc; close all;

%% Parameters
a = 1.4; b = 1.6; c = 0.8; d = 0.6;
x0 = 0.1;

%% Soboleva map
smht = @(x) (exp(a*x) - exp(-b*x)) ./ (exp(c*x) + exp(-d*x));
f    = @(x,alpha) rem(alpha * smht(x), 1);

%% Bifurcation diagram
alphas    = linspace(0.1, 6, 600);
totalIter = 2000;   % total iterations per alpha
lastIter  = 200;    % points kept

points_alpha = []; 
points_x = [];

for alpha = alphas
    x = x0;
    % burn-in
    for i = 1:(totalIter-lastIter)
        x = f(x,alpha);
    end
    % collect last points
    for i = 1:lastIter
        x = f(x,alpha);
        points_alpha(end+1) = alpha; 
        points_x(end+1)     = x;
    end
end

figure;
plot(points_alpha,points_x,'.k','MarkerSize',1);
xlabel('\alpha'); ylabel('x');
title('Bifurcation Diagram (Soboleva-Rem Map)');
grid on;
