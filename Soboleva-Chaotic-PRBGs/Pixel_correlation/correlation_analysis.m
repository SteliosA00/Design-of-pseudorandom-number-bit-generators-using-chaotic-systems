clear; clc; close all;

%% 1. Load images
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

OriginalImg  = double(OriginalImg);
ShuffledImg  = double(ShuffledImg);
EncryptedImg = double(EncryptedImg);

%% 3. Compute correlation coefficients
[OH, OV, OD] = pixelCorrelation(OriginalImg);
[SH, SV, SD] = pixelCorrelation(ShuffledImg);
[EH, EV, ED] = pixelCorrelation(EncryptedImg);

corrData = [
    OH, OV, OD;
    SH, SV, SD;
    EH, EV, ED
];

%% 4. Show the three images
figure('Name', 'Encryption Steps', ...
       'NumberTitle', 'off', ...
       'Position', [100 100 1200 350]);

subplot(1,3,1);
imshow(uint8(OriginalImg));
title('Original Image');

subplot(1,3,2);
imshow(uint8(ShuffledImg));
title('Shuffled Image');

subplot(1,3,3);
imshow(uint8(EncryptedImg));
title('Encrypted Image');

%% 5. Show horizontal adjacent-pixel scatter plots
figure('Name', 'Pixel Correlation Scatter Plots', ...
       'NumberTitle', 'off', ...
       'Position', [100 100 1200 400]);

plotScatter(OriginalImg, 'Original Image', 1);
plotScatter(ShuffledImg, 'Shuffled Image', 2);
plotScatter(EncryptedImg, 'Encrypted Image', 3);

%% 6. Show correlation coefficient table
figure('Name', 'Correlation Coefficients', ...
       'NumberTitle', 'off', ...
       'Position', [300 300 750 250]);

axis off;

rowNames = {'Original', 'Shuffled', 'Encrypted'};
colNames = {'Horizontal', 'Vertical', 'Diagonal'};

uitable('Data', corrData, ...
        'RowName', rowNames, ...
        'ColumnName', colNames, ...
        'Units', 'normalized', ...
        'Position', [0.05 0.15 0.9 0.7]);

%% 7. Save figures
saveas(1, '5_Encryption_Steps.png');
saveas(2, '6_Pixel_Correlation_Scatter.png');

%% 8. Print coefficients
fprintf('\nPixel Correlation Coefficients:\n');
fprintf('--------------------------------------------------\n');
fprintf('%-12s %-12s %-12s %-12s\n', ...
        'Image', 'Horizontal', 'Vertical', 'Diagonal');
fprintf('--------------------------------------------------\n');
fprintf('%-12s %-12.6f %-12.6f %-12.6f\n', ...
        'Original', OH, OV, OD);
fprintf('%-12s %-12.6f %-12.6f %-12.6f\n', ...
        'Shuffled', SH, SV, SD);
fprintf('%-12s %-12.6f %-12.6f %-12.6f\n', ...
        'Encrypted', EH, EV, ED);
fprintf('--------------------------------------------------\n');

fprintf('\nSaved figures:\n');
fprintf('5_Encryption_Steps.png\n');
fprintf('6_Pixel_Correlation_Scatter.png\n');
fprintf('7_Correlation_Coefficients.png\n');

%% ============================================================
%% Function: Compute correlation coefficients
function [horizontalCorr, verticalCorr, diagonalCorr] = pixelCorrelation(img)

    % Horizontal neighboring pixels
    xH = img(:, 1:end-1);
    yH = img(:, 2:end);

    % Vertical neighboring pixels
    xV = img(1:end-1, :);
    yV = img(2:end, :);

    % Diagonal neighboring pixels
    xD = img(1:end-1, 1:end-1);
    yD = img(2:end, 2:end);

    horizontalCorr = corr2(xH, yH);
    verticalCorr   = corr2(xV, yV);
    diagonalCorr   = corr2(xD, yD);

end

%% ============================================================
%% Function: Scatter plot for adjacent pixels
function plotScatter(img, plotTitle, position)

    % Horizontal neighboring pixels
    x = img(:, 1:end-1);
    y = img(:, 2:end);

    x = x(:);
    y = y(:);

    numSamples = min(50000, length(x));
    idx = randperm(length(x), numSamples);

    subplot(1,3,position);

    scatter(x(idx), y(idx), 3, '.');

    title(plotTitle);
    xlabel('Pixel(i)');
    ylabel('Pixel(i+1)');

    xlim([0 255]);
    ylim([0 255]);
    grid on;

end