#rosmake ipc_msgs
#read -p "Make sure there is no error during rosmake then -> Press [Enter] key to continue"
CFLAGS_EXT="-fPIC" 
if [ -z "$MEX" ]; then
    #export MEX=/usr/local/MATLAB/R2012b/bin/mex
    echo No MEX setup, try to search Matlab mex file in /usr/local
    export MEX=$(echo $(find /usr/local -name mex | grep MATLAB) | awk -F " " '{print $1}')
    #
    if [ -z "$MEX" ]; then
    echo "Can't find Matlab mex please export MEX=/path/to/MATLAB/bin/mex"
    read -p "Make sure You have MATLAB installed! Can't make ipc_msgs without mex"
    else
    echo Found matlab mex ,set MEX to $MEX
    fi
fi

if [ -n "$MEX" ]; then
echo MEX= $MEX

rosmake ipc_std_msgs
read -p "Make sure there is no error during rosmake then -> Press [Enter] key to continue"
rosmake ipc_rosgraph_msgs
read -p "Make sure there is no error during rosmake then -> Press [Enter] key to continue"
rosmake ipc_geometry_msgs
read -p "Make sure there is no error during rosmake then -> Press [Enter] key to continue"
rosmake ipc_nav_msgs
read -p "Make sure there is no error during rosmake then -> Press [Enter] key to continue"
rosmake ipc_sensor_msgs
#read -p "Make sure there is no error during rosmake then -> Press [Enter] key to continue"
fi

