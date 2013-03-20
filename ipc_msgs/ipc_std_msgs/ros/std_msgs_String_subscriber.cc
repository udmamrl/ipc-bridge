#include <ros/ros.h>
#include <ipc_bridge/ipc_bridge.h>

#include <std_msgs/String.h>
#include <ipc_bridge/msgs/std_msgs_String.h>

#define NAMESPACE std_msgs
#define NAME String

ros::Publisher pub;
NAMESPACE::NAME out_msg;

void callback(const ipc_bridge::NAMESPACE::NAME &msg)
{
  out_msg.data = std::string(msg.data);

  pub.publish(out_msg);
}

#include "subscriber.h"
