clear all; close all; clc;

bag = rosbag('2018-03-22-14-22-10.bag');
bag_odometry = select(bag, 'Topic', '/firefly/ground_truth/odometry');
bag_images = select(bag, 'Topic', '/firefly/camera/camera_sim/image_raw');

msgs_odometry = readMessages(bag_odometry);
msgs_images = readMessages(bag_images, 1:bag_images.NumMessages);

ts_odometry = timeseries(bag_odometry, 'Pose.Pose.Position.X', ...
    'Pose.Pose.Position.Y', 'Pose.Pose.Position.Z', 'Pose.Pose.Orientation.X', ...
    'Pose.Pose.Orientation.Y', 'Pose.Pose.Orientation.Z', 'Pose.Pose.Orientation.W');
times = linspace(bag_images.StartTime, bag_images.EndTime, size(msgs_images,1));

ts_odometry_resampled = resample(ts_odometry, times);

image_counter = 1;

for i = 1:size(msgs_images,1)

    % Compute orientation from which image was taken.
    measurement_orientation_quat = ts_odometry_resampled.Data(i,4:7);
    measurement_orientation_eul = quat2eul([measurement_orientation_quat(4), ...
        measurement_orientation_quat(1:3)]);
    measurement_orientation_eul = rad2deg(measurement_orientation_eul);
    % If UAV was tilting too much, skip this measurement.
    if (any(measurement_orientation_eul > 5))
        continue;
    end
    
    image = readImage(msgs_images{i});
    imwrite(image,fullfile([pwd, '/images/image', ...
        num2str(image_counter, '%04d'),'.jpg']));
    
    image_counter = image_counter + 1;
    
end

save ts_odometry_resampled.mat ts_odometry_resampled