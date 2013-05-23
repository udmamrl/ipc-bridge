classdef ipc_ros < handle
    %ipc_ros class for ipc-bridge-matlab
    %     
    % obj = ipc_ros(package_, type_, name_, mode_)
    % package_ 
    %         ipc_std_msgs 
    %         ipc_sensor_msgs 
    %         ipc_nav_msgs 
    %         ipc_geometry_msgs 
    %         ipc_rosgraph_msgs
    % type_
    %         geometry_msgs_Point
    %         geometry_msgs_Point32
    %         geometry_msgs_PointStamped
    %         geometry_msgs_Pose
    %         geometry_msgs_PoseArray
    %         geometry_msgs_PoseStamped
    %         geometry_msgs_PoseWithCovariance
    %         geometry_msgs_PoseWithCovarianceStamped
    %         geometry_msgs_Quaternion
    %         geometry_msgs_Transform
    %         geometry_msgs_Twist
    %         geometry_msgs_TwistStamped
    %         geometry_msgs_TwistWithCovariance
    %         geometry_msgs_Vector3
    %         geometry_msgs_Vector3Stamped
    %         geometry_msgs_Wrench
    %         nav_msgs_GridCells
    %         nav_msgs_MapMetaData
    %         nav_msgs_OccupancyGrid
    %         nav_msgs_Odometry
    %         nav_msgs_Path
    %         rosgraph_msgs_Header
    %         sensor_msgs_ChannelFloat32
    %         sensor_msgs_Image
    %         sensor_msgs_Imu
    %         sensor_msgs_LaserScan
    %         sensor_msgs_PointCloud
    %         std_msgs_Bool
    %         std_msgs_String
    % name_ 
    %        also the message parameter's value in launch file
    %        example
    %        <param name="message" value="image" />       
    %         ipc_geometry_msgs : point
    %         ipc_geometry_msgs : point32
    %         ipc_geometry_msgs : pointstamped
    %         ipc_geometry_msgs : pose
    %         ipc_geometry_msgs : posearray
    %         ipc_geometry_msgs : posestamped
    %         ipc_geometry_msgs : posewithcovariance
    %         ipc_geometry_msgs : posewithcovariancestamped
    %         ipc_geometry_msgs : quaternion
    %         ipc_geometry_msgs : transform
    %         ipc_geometry_msgs : twist
    %         ipc_geometry_msgs : twiststamped
    %         ipc_geometry_msgs : twistwithcovariance
    %         ipc_geometry_msgs : vector3
    %         ipc_geometry_msgs : vector3stamped
    %         ipc_geometry_msgs : wrench
    %         ipc_nav_msgs      : gridcells
    %         ipc_nav_msgs      : mapmetadata
    %         ipc_nav_msgs      : occupancygrid
    %         ipc_nav_msgs      : odometry
    %         ipc_nav_msgs      : path
    %         ipc_rosgraph_msgs : header
    %         ipc_sensor_msgs   : channelfloat32
    %         ipc_sensor_msgs   : image
    %         ipc_sensor_msgs   : imu
    %         ipc_sensor_msgs   : laserscan
    %         ipc_sensor_msgs   : pointcloud
    %         ipc_std_msgs      : bool
    %         ipc_std_msgs      : string
    % mode_
    %         'publisher'
    %         'subscriber'
    %---------------------------------------------------------------------
    % obj = ipc_ros(package_, type_, name_, mode_)
    %---------------------------------------------------------------------
    % example subscriber
    %
    % imu     = ipc_ros('ipc_sensor_msgs', 'sensor_msgs_Imu', 'imu', 'subscriber');
    % imu_msg = imu.read()
    % imu.disconnect();
    %
    % example publisher
    %
    % Twist_cmd = ipc_ros('ipc_geometry_msgs', 'geometry_msgs_Twist', 'twist', 'publisher');
    % Twist_msg = Twist_cmd.empty();
    % Twist_msg.linear.x = 0.5;
    % Twist_cmd.send(Twist_msg);
    % Twist_cmd.disconnect();
   
    
    properties;
        bridge
        name
        mode
        pid
        connected
    end

    methods;
        function obj = ipc_ros(package_, type_, name_, mode_)
            [a, p] = system(sprintf('/bin/bash -l -c ''rospack find %s''', package_));
            addpath(strcat(p, '/bin'));

            if exist(strcat(p, '/ipc/bin')) == 7
                addpath(strcat(p, '/ipc/bin'));
            end

            obj.bridge = str2func(type_);
            try
                msg = obj.bridge('empty');
            catch
                error(sprintf('ipc_ros (%s): failed to construct bridge', type_));
                return;
            end

            obj.name = name_;
            if strcmp('publisher', mode_)
                obj.mode = 'publisher';
            elseif strcmp('subscriber', mode_)
                obj.mode = 'subscriber';
            else
                error('ipc_ros (%s): publisher or subscriber required', obj.name);
                return;
            end

            obj.connected = false;
            obj.connect();
        end

        function connect(obj)
            if ~obj.connected
                obj.pid = obj.bridge('connect', obj.mode, obj.name, obj.name);
            end

            if obj.pid == -1
                error('ipc_ros (%s): failed to connect', obj.name);
            else
                obj.connected = true;
            end
        end

        function disconnect(obj)
            if obj.connected
                obj.bridge('disconnect', obj.pid);
            end
            obj.connected = false;
            obj.pid = [];
        end

        function msg = read(obj, varargin)
            timeout = 10;
            blocking = true;
            if length(varargin) == 1
                timeout = varargin{1};
                blocking = true;
            elseif length(varargin) == 2
                timeout = varargin{1};
                blocking = varargin{2};
            end

            if obj.connected
                msg = obj.bridge('read', obj.pid, timeout);
                if blocking
                    while isempty(msg)
                        msg = obj.bridge('read', obj.pid, timeout);
                    end
                end
            end
        end

        function msg = empty(obj)
            msg = obj.bridge('empty');
        end

        function send(obj, msg)
            if ~strcmp(obj.mode, 'publisher')
                error('ipc_ros (%s): failed to send message - wrong mode', obj.name);
                return;
            elseif ~obj.connected
                error('ipc_ros (%s): failed to send message - not connected', obj.name);
                return;
            end

            obj.bridge('send', obj.pid, msg);
        end
    end
end
