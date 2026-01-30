#!/bin/bash

# Make build dir
cd ..
mkdir build

# Load required modules
module purge
module load CMake/3.26.3-GCCcore-12.3.0
module load Python/3.11.3-GCCcore-12.3.0
module load OpenMPI/4.1.5-GCC-12.3.0
module load OpenBLAS/0.3.23-GCC-12.3.0

# Load venv
export VENV=$FASTDATA/lammps-venv
source $VENV/bin/activate

# Define build
cmake -S cmake -B build -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX=$VENV \
    -D BUILD_MPI=yes -D BUILD_OMP=yes -D BUILD_LIB=yes -D BUILD_SHARED_LIBS=yes \
    -D Python_EXECUTABLE=$(which python) -D PKG_PYTHON=yes \
    -D DOWNLOAD_VORO=yes -D PKG_VORONOI=yes \
    -D PKG_MANYBODY=yes -D PKG_EXTRA-FIX=yes -D EXTRA-COMPUTE=yes -D PKG_REPLICA=yes -D PKG_MEAM=yes

# Build in parallel
cmake --build build --parallel 8

cmake --install build
cd build
make install-python

cd ..
rm -r build

# Modify venv/bin/activate to export lammps libs locations
echo "export LD_LIBRARY_PATH=$VENV/lib64:$LD_LIBRARY_PATH" >> $VENV/bin/activate
