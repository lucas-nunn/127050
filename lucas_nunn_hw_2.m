% Lucas Nunn lucas.nunn@fu-berlin.de
% Intro to Programming 127050
% Assignment 2

% 1. load the eeg data
load('eeg_data_assignment_2.mat');

% 2. mean EEG voltage at 0.1s for occipital & frontal channels
occipital_indices = contains(ch_names, 'O');
frontal_indices = contains(ch_names, 'F');
time_point_index = find(times == 0.1);

% occipital = -0.0536
% frontal   =  0.4213
mean_occipital = mean(eeg(:, occipital_indices, time_point_index), 'all');
mean_frontal = mean(eeg(:, frontal_indices, time_point_index), 'all');

% 3. plot timecourse of mean EEG voltage
% the channels mostly alternate between positive and negative, with some
% convergence at transition points
% the channels vary in amplitude size
% there are probably patterns (sinusoidal) for eeg data in general which accounts for
% the similarities, while there are probably task specific differences
% (visual task eliciting higher responses from visual areas) accounting for
% the differences
mean_eeg = squeeze(mean(eeg, 1));
figure
hold on
plot(times, mean_eeg);

% 4. plot timecourse across occipital and frontal channels
% both timecourses are sinusoidal because eeg data is generally sinusoidal
% the occipital timecourse has much greater amplitudes, most likely because
% the given task was visual
mean_occipital_timecourse = mean(mean_eeg(occipital_indices, :));
mean_frontal_timecourse = mean(mean_eeg(frontal_indices, :));
plot(times, mean_occipital_timecourse,LineWidth=3);
plot(times, mean_frontal_timecourse,LineWidth=3)

% 5. plot timecourse across occipital and frontal channels for certain
% images
% the two curves follow the same trajectory, likely because the primary
% brain operations are largely the same
% the small variations in voltages may be due to chance or subtle
% differences in image processing
occipital_first_image = squeeze(mean(eeg(1, occipital_indices, :), 1));
occipital_second_image = squeeze(mean(eeg(2, occipital_indices, :), 1));
plot(times, mean(occipital_first_image), LineStyle="-.", LineWidth=4)
plot(times, mean(occipital_second_image), LineStyle="-.", LineWidth=4)