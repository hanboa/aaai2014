function outputCode = encode(Data, Dictionary)
projection = Data*Dictionary;
absProjection = abs(projection);
reduction = zeros(size(Data'));
outputCode = zeros(size(projection));
newData = Data;

for chosenIndex = 1 : size(projection, 2)/20 
    [maxValue, maxIndice] = max(absProjection, [], 2);
    for i = 1 : size(projection, 1)
        outputCode(i, maxIndice(i)) = 1;
        maxValue(i) = projection(i, maxIndice(i));
        reduction(:, i) = maxValue(i)*Dictionary(:, maxIndice(i));
    end 
    newData = newData - reduction';
    projection = newData*Dictionary;
    absProjection = abs(projection);
end

outputCode = compactbit(outputCode);