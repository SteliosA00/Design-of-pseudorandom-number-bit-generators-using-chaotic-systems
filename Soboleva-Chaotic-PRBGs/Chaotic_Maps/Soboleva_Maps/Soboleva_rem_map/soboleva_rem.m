% smht_tent_prbg_for_nist.m

clear; clc;
rng('shuffle');

%% Parameters
a = 1.4;
b = 1.6;
c = 0.8;
d = 0.6; 
alpha = 3.95; % Control parameter (instead of mu)
x0 = 0.1; % Initial condition
iterations = 7e6;  % Number of iterations (each gives 16 bits)
targetBits = 100e6; % 100 Mbits for NIST 

%% Soboleva function definition
smht = @(x) (exp(a*x) - exp(-b*x)) ./ (exp(c*x) + exp(-d*x));

%% Initialization
x = zeros(1, iterations);
x(1) = x0;
bits = false(1, iterations * 16); % Preallocate bit array

%% Chaotic iteration + bit extraction
for i = 1:iterations-1
    x(i+1) = rem(alpha * smht(x(i)), 1);
    val = floor(rem(1e12 * abs(x(i+1)), 2^16));
    bits((i-1)*16 + 1 : i*16) = int2bit(uint16(val), 16);
end

%% Ensure enough bits for NIST test
if length(bits) < targetBits
    error('Not enough bits generated. Increase iterations.');
end

bits = bits(1:targetBits);

%% Convert logical bits to ASCII '0'/'1'
bitChars = char(bits + '0');

%% Save to file "epsilon"
fid = fopen('epsilon_sob_rem', 'w');
fwrite(fid, bitChars, 'char');
fclose(fid);

fprintf('Wrote exactly %.0f bits to "epsilon".\n', targetBits);
