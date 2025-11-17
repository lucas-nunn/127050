%% Assignment 5
% Intro to Programming 127050 MCNB FU Berlin
% Lucas Nunn lucas.nunn@fu-berlin.de

load("data_assignment_5.mat");

%% Helper functions
% stolen from train_test_eeg_encoding_models.m

function [weights, intercepts] = trainLinear(eegTrain, dnnTrain)
% train linear regressions between deep neural network and EEG dataset
% one independent linear regression for each EEG channel and time point

    [~, numChannels, numTime] = size(eegTrain);
    numFeatures = size(dnnTrain, 2);

    W = zeros(numFeatures, numChannels, numTime);
    b = zeros(numChannels, numTime);

    for ch = 1:numChannels
        for t = 1:numTime
            
            % Extract EEG responses for this channel/time over all trials
            y = eegTrain(:, ch, t);   % [N x 1]
            
            % Fit linear regression: y = DNN*w + b
            mdl = fitlm(dnnTrain, y);
            
            % Save parameters
            W(:, ch, t) = mdl.Coefficients.Estimate(2:end); % weights
            b(ch, t)    = mdl.Coefficients.Estimate(1);     % intercept
        end
    end

    weights = W;
    intercepts = b;
end

function eegPredictions = predictEEG(dnnTest, weights, intercepts)
% used encoding models to predict EEG data from test images

    [numTest, ~] = size(dnnTest);
    [~, numChannels, numTime] = size(weights);
    
    eeg_test_pred = zeros(numTest, numChannels, numTime); % predictions
    
    for ch = 1:numChannels
        for t = 1:numTime
            eeg_test_pred(:, ch, t) = dnnTest * weights(:, ch, t) + intercepts(ch, t);
        end
    end

    eegPredictions = eeg_test_pred;
end

function meanR = correlation(eegTest, eegPrediction)
% calculate Pearson correlation between eeg test data and predicted eeg
% data

    [~, Nchannels, Ntime] = size(eegTest);
    
    % Preallocate correlation matrix
    R = zeros(Nchannels, Ntime);
    
    for ch = 1:Nchannels
        for t = 1:Ntime
            % Get test responses across images
            real_vec = squeeze(eegTest(:, ch, t));
            pred_vec = squeeze(eegPrediction(:, ch, t));
    
            % Compute Pearson correlation
            R(ch, t) = corr(real_vec, pred_vec, 'Type', 'Pearson');
        end
    end

    meanR = mean(R,1);
end

%% Train eeg encoding models using different amounts of training images
IMAGE_QUANTITIES = [250, 1000, 10000, 16540];
 
figure;
for i = 1:length(IMAGE_QUANTITIES)
    numImages = IMAGE_QUANTITIES(i);
    eegTrain = eeg_train(1:numImages, :, :);
    dnnTrain = dnn_train(1:numImages, :);

    [weights, intercepts] = trainLinear(eegTrain, dnnTrain);
    eegPredictions = predictEEG(dnn_test, weights, intercepts);
    meanR = correlation(eeg_test, eegPredictions);
    plot(meanR);
    hold on
end
legend(string(IMAGE_QUANTITIES))
hold off

%% Train eeg encoding models using different amounts of DNN features
DNN_FEATURES = [25, 50, 75, 100];

figure;
for i = 1:length(DNN_FEATURES)
    numFeatures = DNN_FEATURES(i);
    dnnTrain = dnn_train(:, 1:numFeatures);

    [weights, intercepts] = trainLinear(eegTrain, dnnTrain);
    eegPredictions = predictEEG(dnn_test(:, 1:numFeatures), weights, intercepts);
    meanR = correlation(eeg_test, eegPredictions);
    plot(meanR);
    hold on
end
legend(string(IMAGE_QUANTITIES))
hold off

%% Thoughts
% The prediction accuracy is highest soon after viewing the image, likely
% because the dominant response occurs quickly, followed by less
% predictable noice

% The prediction accuracy improves with increasing training set size in
% both cases. For more images, there are more image properties for the model
% to learn, more edge cases to incorporate, and more true properties to
% represent versus noise and outliers. However, once the model reaches a
% certain number of images, performance no longer improves. This is likely
% due to overfitting. For more features, there is more space in the model
% to embed image properties, and thus a greater capacity for learning