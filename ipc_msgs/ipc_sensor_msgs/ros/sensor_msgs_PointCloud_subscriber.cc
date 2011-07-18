#include <ros/ros.h>
#include <ipc_bridge/ipc_bridge.h>

#include <sensor_msgs/PointCloud.h>
#include <ipc_bridge/msgs/sensor_msgs_PointCloud.h>

#define NAMESPACE sensor_msgs
#define NAME PointCloud

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

  out_msg.points.resize(msg.points_length);
  for (unsigned int i = 0; i < msg.points_length; i++)
    {
      out_msg.points[i].x = msg.points[i].x;
      out_msg.points[i].y = msg.points[i].y;
      out_msg.points[i].z = msg.points[i].z;
    }

  pub.publish(out_msg);
}

#include "subscriber.h"
