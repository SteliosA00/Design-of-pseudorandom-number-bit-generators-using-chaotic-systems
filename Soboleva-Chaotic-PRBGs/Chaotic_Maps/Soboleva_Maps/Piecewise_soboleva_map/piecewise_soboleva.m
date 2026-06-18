% smht_tanh_prbg_for_nist.m

clear; clc; rng('shuffle');

%% Parameters
r = 2;              % shape control parameter 
b = 1;               % 0 = even symmetry, 1 = odd symmetry
x0 = 0.1;           
iterations = 7e6;    % number of iterations (each gives 16 bits)
targetBits = 100e6;  % total bits to save (for NIST test)
a = 1.2; b1 = 1.8; c = 0.6; d = 0.4;   % Soboleva parameters

%% Initialize
x = zeros(1, iterations);
x(1) = x0;
bits = false(1, iterations * 16);

%% PRBG main loop
for i = 1:iterations-1
    x(i+1) = smhtMap(x(i), r, b, a, b1, c, d);
    val = floor(rem(1e12 * abs(x(i+1)), 2^16));  % 16-bit integer
    bits((i-1)*16 + 1 : i*16) = int2bit(uint16(val), 16);
end

%% Ensure we have enough bits
if length(bits) < targetBits
    error('Not enough bits generated. Increase iterations.');
end
bits = bits(1:targetBits);

%% Convert to ASCII '0'/'1'
bitChars = char(bits + '0');

%% Save to file
fid = fopen('epsilon_sob_piece', 'w');
fwrite(fid, bitChars, 'char');
fclose(fid);

fprintf('Wrote exactly %.0f bits to "epsilon".\n', targetBits);

%% ------------------------------------------------------------
%% Chaotic tanh map function (piecewise form)
function fx = smhtMap(x, r, b, a, b1, c, d)
smht = @(x) (exp(a*x) - exp(-b1*x)) ./ (exp(c*x) + exp(-d*x));
e = 2 / smht(r);

if x < 0
    fx = e * smht(r * (x + 1)) - 1;
else
    fx = (-1)^b * (e * smht(-r * (x - 1)) - 1);
end
end
