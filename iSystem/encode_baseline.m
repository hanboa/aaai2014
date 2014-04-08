function outputCode = encode_baseline(Data, Dictionary)
    projection = Data*Dictionary;
    Y = zeros(size( projection ));
    Y(projection>=0) = 1;
    % Compact bits
    outputCode = compactbit(Y);    
end
