function output = query(numQuery, numRetrieve)
querySet = struct();

% parameters for query
if ~exist('numQuery'),
    numQuery = 1;
    [filename, pathname]= uigetfile(sprintf('%s/../queries/*.*g',pwd), 'Query');% get the query image by yourself
    filename = fullfile(pathname, filename);
    display(filename)
end
if ~exist('numRetrieve'),
    numRetrieve = 6;
end

% load data from indexed database, dictionary
clear database;
db = load('database.mat');
database = db.database;
clear db;
load dictionary_L1_b512_30600sampling_20140103T010408.mat
Dic = B;

% parameters for sampling patches
windowSize = 14;% the window size of a patch
num_totalSamples = 1000;% the number for sampling total patches
rand_values = struct();

% query and read the data from "queries"
path = '../queries/*.*g';
imgs = dir(path);
i = numQuery;
img_path = filename;

% show query image
scrsz = get(0,'ScreenSize');
im = imread(img_path);
fighandle1 = figure;
set(fighandle1,'OuterPosition',[scrsz(2),scrsz(3),300,300]);
imshow(im);title('Query Image');
    
img = imread(img_path);
img = filter_whiten(img);

querySet(i).name = imgs(i).name;
querySet(i).category = getCategory( imgs(i).name );
totalCount = ones(length(database));

h = waitbar(0,'Processing Query...');

% Image encoding
for iteration = 1 : 10
    % get image patches for the query
    [X_patches rand_values]= getdata_imagepatch(img, windowSize, num_totalSamples);
    X = X_patches';

    % Dictioanry projection
    %display 'Dictionary Projection:'
%     re = X*Dic; % 153x512
%     re = abs(re);
%     
%     % binary code
%     Average_re = sum(sum(re))/(size(re,1)*size(re,2));
%     Y = zeros(size(re));
%     re = re-Average_re;
%     Y(re>=0) = 1;
% 
%     % Compact bits
%     Y = compactbit(Y);

    Y = encode(X, Dic);

    % storing data to querySet
    querySet(i).code = Y;
    
    % Hamming distance
    %display 'Hamming Distance:'
    querySet(i).diffenence = zeros(length(database),1);
    for j = 1 : length(database),
       B1 = querySet(i).code;
       B2 = database(j).code;
       
       % calculate hamming distance
       querySet(i).difference(j,1) = hammingDist(B1, B2);
       %display( sprintf('Checking Database: [%d/%d]', j,length(database)) );
    end
    [querySet(i).sortedValues querySet(i).sortedIndex] = sort(querySet(i).difference);
    for j = 1 : numRetrieve,
        index = querySet(i).sortedIndex(j);
        totalCount(index,1) = totalCount(index,1)*1.2;
    end
    totalCount = totalCount.*0.9;
    
    waitbar(iteration/10);
end
close(h);

[sortedValues, sortedIndex] = sort(totalCount, 'descend');
    
% show retrieved images
fighandle2 = figure;
set(fighandle2,'OuterPosition',[scrsz(3),scrsz(4),900,900]);
if numRetrieve < 3
    Numrow = 1;
else
    Numrow = 2;
end
Numcolumn = ceil(numRetrieve/Numrow);
for j = 1 : numRetrieve,
    index = sortedIndex(j);
    db = database(index);
    path = sprintf('../dataset/%s', db.name);
    im = imread(path);
    subplot(Numrow, Numcolumn, j);
    imshow(im);
end
suptitle('Retrieved Images');
display( sprintf('Query Done: [%d/%d]', i,length(imgs)) );

end
