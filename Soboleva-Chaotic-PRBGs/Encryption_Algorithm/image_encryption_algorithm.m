%% Chaotic Image Encryption using SMHT PRBG
% Uses pixel shuffling + pixel substitution
% Saves:
% 1_Original_Cameraman.png
% 2_Shuffled_Cameraman.png
% 3_Encrypted_Cameraman.png

clear; clc; close all;
rng('shuffle');

%% 1. Parameters

%Add your desired parameters based on your function%

a = 1.4;
b = 1.6;
c = 0.8;
d = 0.6;

alpha = 3.95;   % Control parameter
x0 = 0.1;        % Initial condition

%% 2. Load desired image
A = imread('cameraman.tif');

if size(A,3) == 3
    A = rgb2gray(A);
end

A = uint8(A);
[rows, cols] = size(A);
N = rows * cols;

%% 3. Soboleva / SMHT function 
%Comment this if is not needed for your map

smht = @(x) (exp(a*x) - exp(-b*x)) ./ ...
    (exp(c*x) + exp(-d*x));

%% 4. Generate chaotic sequence

%Replace x(i+1) = rem(alpha * smht(x(i)), 1) with the desired chaotic map%
% Example Logistic Map: % x(i+1) = r*x(i)*(1-x(i));
% Example Sine Map: % x(i+1) = r*sin(pi*x(i));
% Example Tent Map: % x(i+1) = mu*(1-2*abs(x(i)-0.5));

x = zeros(1, N);
x(1) = x0;

for i = 1:N-1
    x(i+1) = rem(alpha * smht(x(i)), 1);
end

%% 5. Stage 1: Pixel shuffling
plainVector = A(:);

[~, idx] = sort(x);
shuffledVector = plainVector(idx);

ShuffledImg = reshape(shuffledVector, rows, cols);

%% 6. Stage 2: Pixel substitution

val16 = uint16(mod(floor(abs(x) * 1e12), 2^16));

% Split 16-bit value into two 8-bit parts
highByte = uint8(bitshift(val16, -8));      % upper 8 bits
lowByte  = uint8(bitand(val16, 255));       % lower 8 bits

% Mix both bytes to use the full 16-bit output
keyStream = bitxor(highByte, lowByte);

keyStream = reshape(keyStream, rows, cols);

EncryptedImg = bitxor(ShuffledImg, keyStream);

%% 7. Save images
imwrite(A, '1_Original_Cameraman.png');
imwrite(ShuffledImg, '2_Shuffled_Cameraman.png');
imwrite(EncryptedImg, '3_Encrypted_Cameraman.png');

%% 8. Display images
figure('Name', 'SMHT Image Encryption', 'NumberTitle', 'off');

subplot(1,3,1);
imshow(A);
title('1. Original');

subplot(1,3,2);
imshow(ShuffledImg);
title('2. Shuffled');

subplot(1,3,3);
imshow(EncryptedImg);
title('3. Encrypted');

fprintf('Encryption complete.\n');
fprintf('Image size: %dx%d\n', rows, cols);
fprintf('Saved images:\n');
fprintf('1_Original_Cameraman.png\n');
fprintf('2_Shuffled_Cameraman.png\n');
fprintf('3_Encrypted_Cameraman.png\n');
