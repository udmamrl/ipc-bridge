#include <ros/ros.h>
#include <ipc_bridge/ipc_bridge.h>

#include <geometry_msgs/TwistStamped.h>
#include <ipc_bridge/msgs/geometry_msgs_TwistStamped.h>

#define NAMESPACE geometry_msgs
#define NAME TwistStamped

ipc_bridge::Publisher<ipc_bridge::NAMESPACE::NAME> *p;
ipc_bridge::NAMESPACE::NAME out_msg;

unsigned int frame_id_prior_size = 0;

void callback(const NAMESPACE::NAME::ConstPtr &msg)
{
  out_msg.header.seq = msg->header.seq;
  out_msg.header.stamp = msg->header.stamp.toSec();

  if (strlen(msg->header.frame_id.c_str()) != frame_id_prior_size)
    {
      if (out_msg.header.frame_id != 0)
        delete[] out_msg.header.frame_id;

      out_msg.header.frame_id =
        new char[strlen(msg->header.frame_id.c_str()) + 1];
      strcpy(out_msg.header.frame_id, msg->header.frame_id.c_str());
      frame_id_prior_size = strlen(msg->header.frame_id.c_str());
    }

  out_msg.twist.linear.x = msg->twist.linear.x;
  out_msg.twist.linear.y = msg->twist.linear.y;
  out_msg.twist.linear.z = msg->twist.linear.z;

  out_msg.twist.angular.x = msg->twist.angular.x;
  out_msg.twist.angular.y = msg->twist.angular.y;
  out_msg.twist.angular.z = msg->twist.angular.z;

  p->Publish(out_msg);
}

#include "publisher.h"
