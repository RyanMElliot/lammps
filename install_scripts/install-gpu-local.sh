#!/bin/bash

cd ..
mkdir build
cd build

# Load the virtual environment
export VIRTUAL_ENV=/home/ryan-elliot/envs/lammps-gpu
source $VIRTUAL_ENV/bin/activate

cmake ../cmake \
    -D PKG_GPU=ON -D GPU_API=cuda \
    -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=$VIRTUAL_ENV \
    -D BUILD_LIB=ON -D BUILD_SHARED_LIBS=ON -D BUILD_MPI=ON -D BUILD_OMP=ON -D PKG_PYTHON=ON \
    -D DOWNLOAD_VORO=ON -D PKG_VORONOI=ON -D PKG_MANYBODY=ON -D PKG_EXTRA-FIX=ON -D EXTRA-COMPUTE=ON -D PKG_REPLICA=ON -D PKG_MEAM=ON

cmake --build . -- -j 2

make install
make install-python

cd ..
rm -r build

# Modify the venv activate script to include LAMMPS libraries in LD_LIBRARY_PATH
echo 'export LD_LIBRARY_PATH=$VIRTUAL_ENV/lib64:$LD_LIBRARY_PATH' >> $VIRTUAL_ENV/bin/activate
