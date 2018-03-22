input_dir = 'images_gt';
output_dir = 'images_annot';

image_files = dir(fullfile(input_dir, '*.png'));

for i = 1:length(image_files)
    
    input_file_name = fullfile(input_dir, image_files(i).name);
    image = imread(input_file_name);
    image_annot = zeros(size(image,1), size(image,2));
    % Annotate weeds.
    image_annot(find(image(:,:,1) == 255)) = 2;
    % Annotate crops.
    image_annot(find(image(:,:,2) == 255)) = 1;
    output_file_name = fullfile(output_dir, image_files(i).name);
    imwrite(image_annot, output_file_name);
    
end