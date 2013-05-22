#roscd ipc
echo "Install ipc 3.9.1 dependency"
sudo apt-get install bison flex 
cd ipc-3.9.1
echo "Do First make for ipc"
make
echo "Do Second make for ipc"
make

echo "Copy files to ipc/lib ipc/bin ipc/include"

mkdir ../lib
mkdir ../bin
mkdir ../include
cp -v lib/Linux-3.2/libipc.a ../lib/.
cp -v bin/Linux-3.2/central ../bin/.
cp -v bin/Linux-3.2/xdrgen ../bin/.
cp -v include/ipc.h ../include/.
