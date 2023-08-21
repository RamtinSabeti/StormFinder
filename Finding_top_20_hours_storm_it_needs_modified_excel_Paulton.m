% Load the CSV file (replace 'Chew-Magna-Spillway-rainfall-15min-Qualified.csv' with the actual file path)
rainfall = csvread('Paulton-rainfall-15min-Qualified.csv');

% Calculate the number of data points in a 6-hour window (15 minutes * 24 data points)
dataPointsInWindow = 6 * 60 / 15;

% Calculate cumulative rainfall
cumulativeRainfall = cumsum(rainfall);

% Calculate the differences between cumulative rainfall
rainfallDiff = [cumulativeRainfall(dataPointsInWindow + 1:end) - cumulativeRainfall(1:end - dataPointsInWindow)];

% Find the indices of the rainfall events
[~, topIndices] = sort(rainfallDiff, 'descend');

% Initialize arrays to store storm event information
stormEvents = {}; % Each cell will store [startRow, endRow, totalRainfall] for a storm event
usedRows = false(size(rainfall)); % Boolean array to track used rows

% Populate the stormEvents array with start and end row numbers and total rainfall
for i = 1:length(topIndices)
    startIndex = topIndices(i);
    endIndex = startIndex + dataPointsInWindow - 1;
    
    % Check if the rows are already used
    if any(usedRows(startIndex:endIndex))
        continue; % Skip this storm event if rows are used
    end
    
    totalRainfall = cumulativeRainfall(endIndex) - cumulativeRainfall(startIndex - 1);
    
    startTime = startIndex;
    endTime = endIndex;
    
    stormEvent = [startIndex, endIndex, totalRainfall];
    stormEvents{end + 1} = stormEvent;
    
    % Mark rows as used
    usedRows(startIndex:endIndex) = true;
    
    % Break loop if enough events have been found
    if length(stormEvents) >= 20
        break;
    end
end

% Display the start, end row numbers, and total rainfall for each storm event
disp('Start and end row numbers along with total rainfall for each 6-hour storm event:');
for i = 1:length(stormEvents)
    fprintf('Storm Event %d: Start Row %d, End Row %d, Total Rainfall %.2f mm\n', ...
        i, stormEvents{i}(1), stormEvents{i}(2), stormEvents{i}(3));
end
