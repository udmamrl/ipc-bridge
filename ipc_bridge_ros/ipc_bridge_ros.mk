ROS_CXXFLAGS = $(PKG_CXXFLAGS)
ROS_CXXFLAGS += $(foreach path, $(shell rospack cflags-only-I $(PKG)), -I$(path))
ROS_CXXFLAGS += $(foreach path, $(shell rospack cflags-only-I ipc_bridge_ros), -I$(path))
ROS_CXXFLAGS += $(foreach path, $(shell rospack cflags-only-I ipc), -I$(path))

ROS_LFLAGS = $(shell rospack libs-only-other roscpp)
ROS_LFLAGS += $(foreach path, $(shell rospack libs-only-L roscpp), -L$(path))
ROS_LFLAGS += $(foreach path, $(shell rospack libs-only-L ipc)   , -L$(path))

ROS_LIBS = $(foreach lib, $(shell rospack libs-only-l roscpp), -l$(lib))

ros: $(ROS_FILES)

%: ros/%.cc
	$(CXX) $(CXXFLAGS) -I./include $(ROS_CXXFLAGS) $(IPC_BRIDGE_CXXFLAGS) $^ -lstdc++ $(IPC_LFLAGS) -lipc $(ROS_LFLAGS) $(ROS_LIBS) -o bin/$@

