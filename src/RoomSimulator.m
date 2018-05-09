function result = RoomSimulator(T, R, nWall, W, n, L0, M)

maxOrder = 3;

%{
Input:
    T: transmitter (1*2 float)
    R: receiver (1*2 float)
    nWall: number of walls (integer)
    W: walls (nWalls * 4 float)
    n: number of power (integer) default: 2, choosing 1.5
        to counter the single ray model insteaf of beam model
    L0: parameter of decay (float)
    M; material of walls (1 * nWalls float) between 0 and 1
Output:
    result: delay and power of signals (maxSig * 2 float)
%}

% Generate Sources
numSrc = nWall;
for i = 2:maxOrder
    numSrc = numSrc + nWall * (nWall - 1)^(i - 1);
end

sourceCount = 0;
sourcePos = zeros(numSrc, 2);
sourceOrder = zeros(1, numSrc);
sourcePath = zeros(numSrc, maxOrder);
sourceFather = zeros(1, numSrc);
sourceFlag = zeros(1, numSrc);

% First Order
for i = 1:nWall
    sourcePos(i, :) = MirrorSource(T, W(i, :));
    % function result = MirrorSource(src, wall)
    sourceCount = sourceCount + 1;
    sourceOrder(i) = 1;
    sourcePath(i, 1) = i;
    sourceFather(i) = 0;
end

currentSrc = 1; % current processed source
while (sourceOrder(currentSrc) < maxOrder)
    for i = 1:nWall
        % eliminate the last wall
        if (sourcePath(currentSrc, sourceOrder(currentSrc)) == i)
            continue;
        end
        
        % find new source
        sourceCount = sourceCount + 1;
        sourcePos(sourceCount, :) = MirrorSource(sourcePos(currentSrc, :), W(i, :));
        sourceOrder(sourceCount) = sourceOrder(currentSrc) + 1;
        sourcePath(sourceCount, :) = sourcePath(currentSrc, :);
        sourcePath(sourceCount, sourceOrder(sourceCount)) = i;
        sourceFather(sourceCount) = currentSrc;
    end
    % processing next source
    currentSrc = currentSrc + 1;
end

% Validate Sources
for i = 1:sourceCount
    currentID = i;
    currentOrder = sourceOrder(i);
    currentR = R;
    currentT = sourcePos(i, :);
    currentW = W(sourcePath(i, currentOrder), :);
    [isIntersect, pos] = Intersect(currentR, currentT, currentW(1:2), currentW(3:4));
    % function [isIntersect, pos] = Intersect(R, T, P, Q)
    while (isIntersect == 1)
        currentOrder = currentOrder - 1;
        if (currentOrder < 1)
            sourceFlag(i) = 1;  % valid source for source i
            break;
        end
        currentR = pos;
        currentID = sourceFather(currentID);
        currentT = sourcePos(currentID, :);
        currentW = W(sourcePath(currentID, currentOrder), :);
        [isIntersect, pos] = Intersect(currentR, currentT, currentW(1:2), currentW(3:4));
    end
    
end

% Generate Result
countValid = 0;
for i = 1:sourceCount
    if (sourceFlag(i) == 1)
        countValid = countValid + 1;
    end
end

result = zeros(countValid, 2);
currentRes = 1;
for i = 1:sourceCount
    if (sourceFlag(i) == 1)
        dist = Distance(R, sourcePos(i, :));
        result(currentRes, 1) = dist / 340;
        decayMaterials = 1;
        for j = 1:sourceOrder(i)
            decayMaterials = decayMaterials * M(sourcePath(i, j));
        end
        result(currentRes, 2) = L0 / (dist^n) * decayMaterials;
        currentRes = currentRes + 1;
    end
end

dirDist = Distance(T, R);
dirLevel = L0 / (dirDist^n);
result(countValid + 1, :) = [dirDist / 340, dirLevel];

end