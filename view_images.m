images_dir = 'images';
images_gt_dir = 'images_gt';

image_files = dir(fullfile(images_dir, '*.jpg'));
image_gt_files = dir(fullfile(images_gt_dir, '*.png'));

for i = 1:length(image_files)
    
    image_file_name = fullfile(images_dir, image_files(i).name);
    image = imread(image_file_name);
    image_gt_file_name = fullfile(images_gt_dir, image_gt_files(i).name);
    image_gt = imread(image_gt_file_name);
    mask_weed = im2bw(image_gt(:,:,1));
    mask_crop = im2bw(image_gt(:,:,2));
    boundaries_weed = bwperim(mask_weed);
    boundaries_crop = bwperim(mask_crop);
    
    red=zeros(size(image_gt,1),size(image_gt,2),3);
    red(:,:,1)=1;
    green=zeros(size(image_gt,1),size(image_gt,2),3);
    green(:,:,2)=1;
    
    hold on
    h_i = imshow(image);
    h_g = imshow(green);
    set(h_g, 'AlphaData', boundaries_crop)
    h_r = imshow(red);
    set(h_r, 'AlphaData', boundaries_weed)
    h_t = text(-50,-8,image_files(i).name,'FontSize',25,'Interpreter','None');
    hold off
    
    waitforbuttonpress
    
    delete(h_i)
    delete(h_g)
    delete(h_r)
    delete(h_t)
    
end