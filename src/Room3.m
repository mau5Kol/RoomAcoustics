clear;

nWall = 6;
W = [1 1 9 1
     9 1 9 9
     9 9 1 9
     1 9 1 7
     1 7 1 3
     1 3 1 1];
T = [3 4];
R = [5 6];
n = 1.5;
M = [0.9 0.85 0.88 1 0.1 1];
L0 = 4;
result = RoomSimulator(T, R, nWall, W, n, L0, M);

figure;
hold on;
for i = 1:size(result, 1)
    line([result(i, 1), result(i, 1)], [result(i, 2), 0]);
end

[dry, fs] = audioread('sample.wav');
dry = dry(:, 1);

% max delay time
maxT = 0;
for i = 1:size(result, 1)
    if (maxT < result(i, 1))
        maxT = result(i, 1);
    end
end

core = zeros(round(maxT * fs), 1);

for i = 1:size(result, 1)
    core(round(result(i, 1) * fs)) = core(round(result(i, 1) * fs)) + result(i, 2);
end

wet = conv(dry, core);
% wet = wet ./ max(abs(wet));

soundsc(wet, fs);
audiowrite('Room3.wav', wet, fs);