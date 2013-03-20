#ifndef __IPC_BRIDGE_MATLAB_STD_MSGS_STRING__
#define __IPC_BRIDGE_MATLAB_STD_MSGS_STRING__
#include <ipc_bridge_matlab/ipc_bridge_matlab.h>
#include <ipc_bridge/msgs/std_msgs_String.h>

namespace ipc_bridge_matlab
{
  namespace std_msgs
  {
    namespace String
    {
      static mxArray* ProcessMessage(const ipc_bridge::std_msgs::String &msg)
      {
        const char *fields[] = {"data"};
        const int nfields = sizeof(fields)/sizeof(*fields);
        mxArray *out = mxCreateStructMatrix(1, 1, nfields, fields);

        if (msg.data == 0)
          {
            char buf[1] = {'\0'};
            mxSetField(out, 0, "data", mxCreateString(buf));
          }
        else
          {
            char buf[strlen(msg.data) + 1];
            strcpy(buf, msg.data);
            mxSetField(out, 0, "data", mxCreateString(buf));
          }

        return out;
      }

      static int ProcessArray(const mxArray *a, ipc_bridge::std_msgs::String &msg)
      {
        mxArray *field;

        field = mxGetField(a, 0, "data");

        int buflen = 128;
        char buf[buflen];
        mxGetString(field, buf, buflen);
        if (strlen(buf) > 0)
          {
            msg.data = new char[strlen(buf) + 1];
            strcpy(msg.data, buf);
          }
        else
          {
            msg.data = new char[1];
            msg.data[0] = '\0';
          }

        return SUCCESS;
      }

      static void Cleanup(ipc_bridge::std_msgs::String &msg)
      {
      }
    }
  }
}
#endif
