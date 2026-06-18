%% Renyi map
clear
x(1) = rand;
beta = 1.5; 
N = 10^5;

for i = 2:N
    x(i) = mod(beta * x(i-1), 1);
end

x = x(200:end); 

figure
plot(x(1:end-1), x(2:end), '.k')
xlabel('x_{i}')
ylabel('x_{i+1}')
grid on
box on
set(gca,'fontsize',12)
set(gca,'fontweight','bold')

figure
plot3(x(1:end-2), x(2:end-1), x(3:end), '.k')
xlabel('x_{i}')
ylabel('x_{i+1}')
zlabel('x_{i+2}')
grid on
box on
set(gca,'fontsize',12)
set(gca,'fontweight','bold')
