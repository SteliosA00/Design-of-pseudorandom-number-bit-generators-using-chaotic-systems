% smht_tent_prbg_for_nist.m
clear; clc; rng('shuffle');

%% Parameters
a = 1; b = 0.7; c = 1; d = 1;   % Soboleva parameters
mu = 3.5;                       % control parameter
x0 = 0.1;                       % initial condition
iterations = 7e6;               % number of iterations (each gives 16 bits)
targetBits = 100e6;             % 100 Mbits for NIST

%% Soboleva function
smht = @(x) (exp(a*x) - exp(-b*x)) ./ (exp(c*x) + exp(-d*x));

%% Initialize
x = zeros(1, iterations);
x(1) = x0;
bits = false(1, iterations*16);   % preallocate

%% PRBG
for i = 1:iterations-1
    x(i+1) = smht(mu * (1 - 2*abs(x(i) - 0.5)));
    val = floor(rem(1e12 * abs(x(i+1)), 2^16)); 
    bits((i-1)*16+1:i*16) = int2bit(uint16(val), 16);
end

%% 100,000,000 bits
if length(bits) < targetBits
    error('Not enough bits generated. Increase iterations.');
end
bits = bits(1:targetBits);

%%ASCII '0'/'1'
bitChars = char(bits + '0');

%% Save
fid = fopen('epsilon_sob_ten','w');
fwrite(fid, bitChars, 'char');
fclose(fid);

fprintf('Wrote exactly %.0f bits to "epsilon".\n', targetBits);
