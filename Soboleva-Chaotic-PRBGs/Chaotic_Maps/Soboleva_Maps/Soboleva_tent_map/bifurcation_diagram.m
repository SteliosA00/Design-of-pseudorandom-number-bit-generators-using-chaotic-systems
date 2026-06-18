clear; clc; close all;

%% Parameters
a = 1; b = 0.7; c = 1; d = 1;
x0 = 0.2;

%% Soboleva map
smht = @(x) (exp(a*x) - exp(-b*x)) ./ (exp(c*x) + exp(-d*x));
f = @(x,mu) smht(mu * (1 - 2*abs(x - 0.5)));

%% Bifurcation diagram
mus = linspace(0.1,4,600);
totalIter = 1000; lastIter = 200;

points_mu = []; points_x = [];

for m = mus
    x = x0;
    % burn-in
    for i = 1:(totalIter-lastIter)
        x = f(x,m);
    end
    % collect last points
    for i = 1:lastIter
        x = f(x,m);
        points_mu(end+1) = m;
        points_x(end+1)  = x;
    end
end

figure;
plot(points_mu,points_x,'.k','MarkerSize',1);
xlabel('\mu'); ylabel('x');
title('Bifurcation Diagram (Soboleva–Tent Map)');
grid on;
