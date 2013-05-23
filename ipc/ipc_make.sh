#!/bin/bash
cd $(rospack find ipc)
echo "Install ipc 3.9.1 dependency : bison flex "
sudo apt-get install bison flex 
cd ipc-3.9.1
echo "Do First make for ipc"
CFLAGS_EXT="-fPIC"
make 
echo "Do Second make for ipc "
make

echo "Copy files to ipc/bin ipc/include"

mkdir ../bin
mkdir ../include
cp -fv bin/Linux-3.2/xdrgen ../bin/.
cp -fv include/ipc.h ../include/.

#
echo "run rosmake ipc to generate libipc.so and central"

rosmake ipc
