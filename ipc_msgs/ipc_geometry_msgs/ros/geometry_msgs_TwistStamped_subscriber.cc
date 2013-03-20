#include <ros/ros.h>
#include <ipc_bridge/ipc_bridge.h>

#include <geometry_msgs/TwistStamped.h>
#include <ipc_bridge/msgs/geometry_msgs_TwistStamped.h>

#define NAMESPACE geometry_msgs
#define NAME TwistStamped

ros::Publisher pub;
NAMESPACE::NAME out_msg;

void callback(const ipc_bridge::NAMESPACE::NAME &msg)
{
  out_msg.header.seq = msg.header.seq;
  out_msg.header.stamp = ros::Time(msg.header.stamp);
  if (msg.header.frame_id != 0)
    out_msg.header.frame_id = std::string(msg.header.frame_id);
  else
    out_msg.header.frame_id = std::string("");

  out_msg.twist.linear.x = msg.twist.linear.x;
  out_msg.twist.linear.y = msg.twist.linear.y;
  out_msg.twist.linear.z = msg.twist.linear.z;

  out_msg.twist.angular.x = msg.twist.angular.x;
  out_msg.twist.angular.y = msg.twist.angular.y;
  out_msg.twist.angular.z = msg.twist.angular.z;

  pub.publish(out_msg);
}

#include "subscriber.h"
