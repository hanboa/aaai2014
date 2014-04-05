function whitenDataset(inputFile)
DATASET = load(inputFile);
dataset=cell2mat(struct2cell(DATASET));
num_images=size(dataset,3);
image_size=size(dataset,1); % square image
SceneClass13_whiten=zeros(image_size,image_size,num_images);
this_image=zeros(image_size,image_size);
disp(num_images);
for i = 1 : num_images
    this_image=dataset(:,:,i);
    SceneClass13_whiten(:,:,i) = filter_whiten(this_image);
end
%fname_save = sprintf('%s_whiten', dataset);
fname_save='SceneClass13_whiten';
save(fname_save, 'SceneClass13_whiten');