clear all;
clc;

[a, p] = system('rospack find ipc_bridge_matlab');
addpath(strcat(p, '/scripts')); 


msg_database={...  
     'ipc_geometry_msgs' , 'geometry_msgs_PoseArray'          , 'posearray'          , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_PoseStamped'        , 'posestamped'        , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_PoseWithCovariance' , 'posewithcovariance' , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Pose'               , 'pose'               , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Quaternion'         , 'quaternion'         , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_TwistStamped'       , 'twiststamped'       , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Twist'              , 'twist'              , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Vector3Stamped'     , 'vector3stamped'     , 'subscriber' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Vector3'            , 'vector3'            , 'subscriber' ; ...
    %'ipc_nav_msgs'      , 'nav_msgs_Odometry'                , 'odometry'           , 'subscriber' ; ...
    %'ipc_sensor_msgs'   , 'sensor_msgs_Image'                , 'image'              , 'subscriber' ; ...
     'ipc_sensor_msgs'   , 'sensor_msgs_Imu'                  , 'imu'                , 'subscriber' ; ...
     'ipc_sensor_msgs'   , 'sensor_msgs_LaserScan'            , 'laserscan'          , 'subscriber' ; ...
     'ipc_sensor_msgs'   , 'sensor_msgs_PointCloud'           , 'pointcloud'         , 'subscriber' ; ...
     'ipc_std_msgs'      , 'std_msgs_Bool'                    , 'bool'               , 'subscriber' ; ...
     'ipc_std_msgs'      , 'std_msgs_String'                  , 'string'             , 'subscriber' ...
           }  ;
 
% Try to publish Image will crash Matlab
% Launch ipc-Image node will kill ipc  
% Empty Odom and String publish fixed
% Subscribe Odom will crash Matlab
% Subscribe Laser will kill laser node ipc_sub_node_laserscan

[m,n]=size(msg_database)
for i=1:m
    %pid = ipc_ros('ipc_geometry_msgs', 'geometry_msgs_Twist', 'twist', 'subscriber');
    pid = ipc_ros(msg_database{i,1}, msg_database{i,2},msg_database{i,3},msg_database{i,4});
    for j=1:2
        if (pid.connected)
            pause(.5)
            display([msg_database{i,2} ' Read from topic:/' msg_database{i,3} '  j=' num2str(j)])
            timeout = 1;
            blocking = false;
            msg=pid.read(timeout,blocking)
            if isempty(msg)
                display(['No message form:' msg_database{i,2}])
            else
                display(['Got message form:' msg_database{i,2}])
                switch (pid.name)
                    case 'posearray'
                        size=msg.poses
                    case 'posestamped'
                        msg.pose.position.x
                        msg.pose.orientation.w
                    case 'posewithcovariance'
                        msg.pose.position.x
                    case 'pose'
                        msg.position.x
                        msg.msg.orientation.w
                    case 'quaternion'
                        msg.w=1;
                    case 'twiststamped'
                        msg.twist.linear.x
                        msg.twist.angular.z
                    case 'twist'
                        msg.linear.x
                        msg.angular.z
                    case 'vector3stamped'
                        msg.vector.x
                    case 'vector3'
                        msg
                    case 'odometry'
                        msg
                    case 'image'
                        msg
                    case 'imu'
                        msg
                    case 'laserscan'
                        msg
                    case 'pointcloud'
                        msg
                    case 'bool'
                        msg
                    case 'string'
                        msg
                end
            end
        end
    end
    
    pid.disconnect();
    pid.delete()
    
    clear pid
    clear msg
    
end
