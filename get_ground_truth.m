%load('ts_odometry_resmapled.mat')

% Ground truth dimensions.
ground_truth = imread('first000_gt_cropped.png');
ground_truth_dim_x = size(ground_truth,1);
ground_truth_dim_y = size(ground_truth,2);

% Measurement locations.
measurement_poses = ts_odometry_resampled.Data;

% Camera FoV angles [deg].
FoV_x = 47.2;
FoV_y = 35.4;

% Ground sample distance [m/pixel].
GSD = 0.0068;

for i = 1:size(measurement_poses,1)
    
    % Compute orientation from which image was taken.
    measurement_orientation_quat = measurement_poses(i,4:7);
    measurement_orientation_eul = quat2eul([measurement_orientation_quat(4), ...
        measurement_orientation_quat(1:3)]);
    measurement_orientation_eul = rad2deg(measurement_orientation_eul);
    % If UAV was tilting too much, skip this measurement.
    if (any(measurement_orientation_eul > 5))
        continue;
    end
    
    % Compute position from which image was taken (pixels).
    measurement_position_px = zeros(1,3);
    measurement_position_px(1) = ...
        (measurement_poses(i,1))/GSD + (ground_truth_dim_x/2);
    measurement_position_px(2) = ...
        (measurement_poses(i,2))/GSD + (ground_truth_dim_y/2);
    measurement_position_px(3) = ...
        measurement_poses(i,3);
    measurement_position_px = round(measurement_position_px);
    
    % Compute camera footprint.
    half_image_size_x = measurement_position_px(3)*tand(FoV_x/2) / GSD;
    half_image_size_y = measurement_position_px(3)*tand(FoV_y/2) / GSD;
    half_image_size_x = round(half_image_size_x);
    half_image_size_y = round(half_image_size_y);
    
    % Crop ground truth image corresponding to the measurement position.
    image_gt = ...
        ground_truth(measurement_position_px(1)-half_image_size_x: ...
        measurement_position_px(1)+half_image_size_x, ...
        measurement_position_px(2)-half_image_size_y: ...
        measurement_position_px(2)+half_image_size_y, :);
    image_gt = imresize(image_gt, [480, 360]);
    image_gt = imrotate(image_gt, 90);
    % Save to folder.
    imwrite(image_gt,fullfile([pwd, '/images_gt/image_gt', ...
        num2str(i, '%04d'),'.png']));    
    
end

