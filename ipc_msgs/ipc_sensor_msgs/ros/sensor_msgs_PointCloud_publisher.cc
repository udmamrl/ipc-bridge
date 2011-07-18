#include <ros/ros.h>
#include <ipc_bridge/ipc_bridge.h>

#include <sensor_msgs/PointCloud.h>
#include <ipc_bridge/msgs/sensor_msgs_PointCloud.h>

#define NAMESPACE sensor_msgs
#define NAME PointCloud

ipc_bridge::Publisher<ipc_bridge::NAMESPACE::NAME> *p;
ipc_bridge::NAMESPACE::NAME out_msg;

void callback(const NAMESPACE::NAME::ConstPtr &msg)
{
  out_msg.header.seq = msg->header.seq;
  out_msg.header.stamp = msg->header.stamp.toSec();

  if (out_msg.header.frame_id != 0)
    delete[] out_msg.header.frame_id;

  out_msg.header.frame_id =
    new char[strlen(msg->header.frame_id.c_str()) + 1];
  strcpy(out_msg.header.frame_id, msg->header.frame_id.c_str());

  out_msg.points_length = msg->points.size();
  out_msg.points = new geometry_msgs_Point32[out_msg.points_length];

  for (unsigned int i = 0; i < out_msg.points_length; i++)
    {
      out_msg.points[i].x = msg->points[i].x;
      out_msg.points[i].y = msg->points[i].y;
      out_msg.points[i].z = msg->points[i].z;
    }

  p->Publish(out_msg);

  if (out_msg.points != 0)
    delete [] out_msg.points;

  out_msg.points = 0;
}
#include "publisher.h"
