clear all;
clc;

[a, p] = system('rospack find ipc_bridge_matlab');
addpath(strcat(p, '/scripts')); 


msg_database={...  
     'ipc_geometry_msgs' , 'geometry_msgs_PoseArray'          , 'posearray'          , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_PoseStamped'        , 'posestamped'        , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_PoseWithCovariance' , 'posewithcovariance' , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Pose'               , 'pose'               , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Quaternion'         , 'quaternion'         , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_TwistStamped'       , 'twiststamped'       , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Twist'              , 'twist'              , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Vector3Stamped'     , 'vector3stamped'     , 'publisher' ; ...
     'ipc_geometry_msgs' , 'geometry_msgs_Vector3'            , 'vector3'            , 'publisher' ; ...
     'ipc_nav_msgs'      , 'nav_msgs_Odometry'                , 'odometry'           , 'publisher' ; ...
     %'ipc_sensor_msgs'   , 'sensor_msgs_Image'                , 'image'              , 'publisher' ; ...
     'ipc_sensor_msgs'   , 'sensor_msgs_Imu'                  , 'imu'                , 'publisher' ; ...
     'ipc_sensor_msgs'   , 'sensor_msgs_LaserScan'            , 'laserscan'          , 'publisher' ; ...
     'ipc_sensor_msgs'   , 'sensor_msgs_PointCloud'           , 'pointcloud'         , 'publisher' ; ...
     'ipc_std_msgs'      , 'std_msgs_Bool'                    , 'bool'               , 'publisher' ; ...
     'ipc_std_msgs'      , 'std_msgs_String'                  , 'string'             , 'publisher' ...
           }  ;
 
% Try to publish Image will crash Matlab
% Empty Odom and Empty String publish fixed  

[m,n]=size(msg_database)
for i=1:m
    %pid = ipc_ros('ipc_geometry_msgs', 'geometry_msgs_Twist', 'twist', 'publisher');
    pid = ipc_ros(msg_database{i,1}, msg_database{i,2},msg_database{i,3},msg_database{i,4});
    msg_database{i,2}
    msg = pid.empty()
    for j=1:20
        pause(.5)
        if (pid.connected)
            switch (pid.name)
                case 'posearray'
                    msg=geometry_msgs_PoseArray('empty');
                    msg.poses{1}=geometry_msgs_Pose('empty');
                    msg.poses{1}.orientation.w=1;
                    msg.poses{1}.position.x=j;
                    msg.poses{2}=geometry_msgs_Pose('empty');
                    msg.poses{2}.orientation.w=1;
                    msg.poses{1}.position.x=-j;
                case 'posestamped'
                    msg=geometry_msgs_PoseStamped('empty');
                    msg.pose.position.x=j;
                    msg.pose.orientation.w=1;
                case 'posewithcovariance'
                    msg=geometry_msgs_PoseWithCovariance('empty');
                    msg.pose.position.x=j;
                case 'pose'
                    msg=geometry_msgs_Pose('empty');
                    msg.position.x=j;
                    msg.msg.orientation.w=1;
                case 'quaternion'
                    msg=geometry_msgs_Quaternion('empty')
                    msg.w=1;
                case 'twiststamped'
                    msg=geometry_msgs_TwistStamped('empty')
                    msg.twist.linear.x=j;
                    msg.twist.angular.z=-j;
                case 'twist'
                    msg=geometry_msgs_Twist('empty')
                    msg.linear.x=j
                    msg.angular.z=-j
                case 'vector3stamped'
                    msg=geometry_msgs_Vector3Stamped('empty')
                    msg.vector.x=j
                case 'vector3'
                    msg=geometry_msgs_Vector3('empty')
                    msg.x=j
                case 'odometry'
                    msg=nav_msgs_Odometry('empty')
                case 'image'
                    msg=sensor_msgs_Image('empty')
                     msg.height=2;
                     msg.width=5;
                     msg.encoding='RGB8';
                     msg.step=msg.width*3;
                     msg.data=[1:msg.height*msg.step];
                case 'imu'
                    msg=sensor_msgs_Imu('empty')
                case 'laserscan'
                    msg=sensor_msgs_LaserScan('empty')
                case 'pointcloud'
                    msg=sensor_msgs_PointCloud('empty')
                case 'bool'
                    msg=std_msgs_Bool('empty')
                    msg.data=~msg.data
                case 'string'    
                    msg=std_msgs_String('empty')
                    msg.data=['Hello World!' num2str(j)]

            end
            pid.send(msg);
            display([msg_database{i,2} ' send to topic:/' msg_database{i,3} '  j=' num2str(j)])
        end
    end
    
    pid.disconnect();
    pid.delete()
    
    clear pid
    clear msg
    
end
