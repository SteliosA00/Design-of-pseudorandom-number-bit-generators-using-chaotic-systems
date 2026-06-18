clear; clc; close all;

%% 1. Load the three encryption stage images
OriginalImg  = imread('1_Original_Cameraman.png');
ShuffledImg  = imread('2_Shuffled_Cameraman.png');
EncryptedImg = imread('3_Encrypted_Cameraman.png');

%% 2. Convert to grayscale if needed
if size(OriginalImg,3) == 3
    OriginalImg = rgb2gray(OriginalImg);
end

if size(ShuffledImg,3) == 3
    ShuffledImg = rgb2gray(ShuffledImg);
end

if size(EncryptedImg,3) == 3
    EncryptedImg = rgb2gray(EncryptedImg);
end

%% 3. Display images and histograms
figure('Name', 'Histogram Analysis of Encryption Steps', ...
    'NumberTitle', 'off', ...
    'Position', [100 100 1100 750]);

% Original
subplot(3,2,1);
imshow(OriginalImg);
title('Original Image');

subplot(3,2,2);
imhist(OriginalImg);
title('Histogram of Original Image');
xlim([0 255]);

% Shuffled
subplot(3,2,3);
imshow(ShuffledImg);
title('Shuffled Image');

subplot(3,2,4);
imhist(ShuffledImg);
title('Histogram of Shuffled Image');
xlim([0 255]);

% Encrypted
subplot(3,2,5);
imshow(EncryptedImg);
title('Encrypted Image');

subplot(3,2,6);
imhist(EncryptedImg);
title('Histogram of Encrypted Image');
xlim([0 255]);

%% 4. Save the histogram analysis figure
saveas(gcf, '4_Histogram_Analysis.png');

fprintf('Histogram analysis complete.\n');
fprintf('Saved figure: 4_Histogram_Analysis.png\n');