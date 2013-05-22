MATLAB_CXXFLAGS = $(PKG_CXXFLAGS)
MATLAB_CXXFLAGS += $(foreach path, $(shell rospack cflags-only-I ipc_bridge_matlab), -I$(path))
MATLAB_CXXFLAGS += $(foreach path, $(shell rospack cflags-only-I ipc), -I$(path))
MATLAB_CXXFLAGS += $(foreach path, $(shell rospack libs-only-L ipc), -L$(path))
mex: $(MEX_FILES)

%: mex/%.cc
	$(MEX) -I./include $(MATLAB_CXXFLAGS) $(IPC_BRIDGE_CXXFLAGS) $^ $(IPC_LFLAGS) -lipc -output bin/$@
