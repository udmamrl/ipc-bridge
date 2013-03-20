#include <ros/ros.h>
#include <ipc_bridge/ipc_bridge.h>

#include <std_msgs/String.h>
#include <ipc_bridge/msgs/std_msgs_String.h>

#define NAMESPACE std_msgs
#define NAME String

ipc_bridge::Publisher<ipc_bridge::NAMESPACE::NAME> *p;
ipc_bridge::NAMESPACE::NAME out_msg;

unsigned int data_prior_size = 0;

void callback(const NAMESPACE::NAME::ConstPtr &msg)
{
  if (strlen(msg->data.c_str()) != data_prior_size)
    {
      if (out_msg.data != 0)
        delete[] out_msg.data;

      out_msg.data = new char[strlen(msg->data.c_str()) + 1];
      strcpy(out_msg.data, msg->data.c_str());
      data_prior_size = strlen(msg->data.c_str());
    }

  p->Publish(out_msg);
}

#include "publisher.h"
