% 
% <launch>
%   <node pkg="ipc_geometry_msgs"    name="ipc_Twist_node"    type="geometry_msgs_Twist_subscriber"   output="screen">
%     <remap from="~topic"     to="/cmd_vel"/>
%     <param name="message" value="twist" />
%   </node>
% </launch>
%-----------------------------------
%
% $ rosrun ipc central -u
%
%%
  Twist_cmd = ipc_ros('ipc_geometry_msgs', 'geometry_msgs_Twist', 'twist', 'publisher');
  Twist_msg = Twist_cmd.empty();
%%
  for i=1:100
      pause(.5)
      Twist_msg.linear.x = i/100;
      Twist_msg.angular.z = 1-i/100;
      
      if (Twist_cmd.connected)
          Twist_cmd.send(Twist_msg);
          display('send twist')
      end
  end
  %%
  Twist_cmd.disconnect();
  Twist_cmd.delete()
 