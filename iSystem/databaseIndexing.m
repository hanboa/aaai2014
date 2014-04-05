function output = databaseIndexing()
database = struct(); 

% read the dictionary
load dictionary_L1_b512_30600sampling_20140103T010408.mat
Dic = B;

% parametes for sampling
windowSize = 14;% the window size of a patch
num_totalSamples = 5000;% the number for sampling total patches
rand_values = struct();

% read the data from dataset
path = '../dataset/*.*g';
imgs = dir(path);
for i = 1 : length(imgs),
    img_path = sprintf('../dataset/%s',imgs(i).name);
    img = imread(img_path);
    img = filter_whiten(img);
    
    % get image patches
    [X_patches rand_values]= ...
        getdata_imagepatch(img, windowSize, num_totalSamples);
    X = X_patches';

    % dictioanry projection
    display 'DICTIONARY'
    % re = X*Dic; % 153x512
    % reAbs = abs(re);

    % binary code
    % Average_re = sum(sum(re))/(size(re,1)*size(re,2));
    % Y = zeros(size(re));
    % re = re-Average_re;
    % Y(re>=0) = 1;
    % compact bits
    % Y = compactbit(Y);
    
    Y = encode(X, Dic);
    
    % storing data to database
    database(i).name = imgs(i).name;
    database(i).category = getCategory( imgs(i).name );
    database(i).code = Y;
    display( sprintf('[%d/%d]', i,length(imgs)) );
end

% save the data
save('database.mat', 'database');


end


