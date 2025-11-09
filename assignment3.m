% Lucas Nunn lucas.nunn@fu-berlin.de
% Intro to Programming 127050
% Assignment 2

%{
1/2 familiar first, 1/2 unfamiliar first
1/3 each emotion first
same emotions presented consecutively
order of emotions random
%}
FAMILIARITY = ["familiar", "unfamiliar"];
EMOTION = ["positive", "neutral", "negative"];
NUM_SUBJECTS = 60;

emotions = perms(EMOTION);
familiar = emotions + " " + FAMILIARITY(1);
unfamiliar = emotions + " " + FAMILIARITY(2);

[height, width] = size(emotions);

selections1 = strings(height, width * 2);
selections1(:, 1:2:end) = familiar;
selections1(:, 2:2:end) = unfamiliar;

selections2 = strings(height, width * 2);
selections2(:, 1:2:end) = unfamiliar;
selections2(:, 2:2:end) = familiar;

selections = repmat([selections1; selections2], 5, 1);
