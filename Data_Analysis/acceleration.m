function [acc_cam, acc_tracker_device, time_cam, time_tracker_device] = acceleration(db_cam, db_tracker_device)

% Call function with sc4_data_person1_preprocessed.csv and
% sc4_data_person1_tracker_deviceprocessed.csv. Then plot that with the
% respective time. Strange result.
time_cam = db_cam(11:110,4)-27,74;
pitch_cam = db_cam(11:110,5);

time_tracker_device = db_tracker_device(444:5672,1);
pitch_tracker_device = db_tracker_device(444:5672,2);


pitch_cam_dt = gradient(pitch_cam, time_cam);
pitch_cam_dt2 = gradient(pitch_cam_dt, time_cam);

pitch_tracker_device_dt = gradient(pitch_tracker_device, time_tracker_device);
pitch_tracker_device_dt2 = gradient(pitch_tracker_device_dt, time_tracker_device);

acc_cam = pitch_cam_dt2;
acc_tracker_device = pitch_tracker_device_dt2;

end