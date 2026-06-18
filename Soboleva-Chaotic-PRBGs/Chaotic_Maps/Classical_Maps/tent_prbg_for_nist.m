clear; clc;
rng('shuffle');

%% Parameters
mu = 1.999999;
x0 = 0.1;
iterations = 7e6;
targetBits = 100e6;

%% Initialization
x = zeros(1, iterations);
x(1) = x0;
bits = false(1, iterations * 16);

%% Tent map + bit extraction
for i = 1:iterations-1
    if x(i) < 0.5
        x(i+1) = mu * x(i);
    else
        x(i+1) = mu * (1 - x(i));
    end

    val = floor(rem(1e12 * abs(x(i+1)), 2^16));
    bits((i-1)*16 + 1 : i*16) = int2bit(uint16(val), 16);
end

bits = bits(1:targetBits);

bitChars = char(bits + '0');

fid = fopen('epsilon_tent', 'w');
fwrite(fid, bitChars, 'char');
fclose(fid);

fprintf('Wrote exactly %.0f bits to "epsilon_tent".\n', targetBits);