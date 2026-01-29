#!/bin/bash

cd ..
mkdir build

cmake -S cmake -B build \
    -D BUILD_MPI=yes -D BUILD_OMP=yes -D BUILD_LIB=yes -D BUILD_SHARED_LIBS=yes \
    -D Python_EXECUTABLE=$(which python3) -D PKG_PYTHON=yes \
    -D DOWNLOAD_VORO=yes -D PKG_VORONOI=yes \
    -D PKG_MANYBODY=yes -D PKG_EXTRA-FIX=yes -D EXTRA-COMPUTE=yes -D PKG_REPLICA=yes -D PKG_MEAM=yes

cmake --build build --parallel 16


cmake --install build
cd build
make install-python

cd ..
rm -r build
