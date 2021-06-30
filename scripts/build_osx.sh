#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset
# Exit script if a statement returns a non-true return value.
set -o errexit

# if [ -z "${JAVA_HOME+UNDEF}" ];then
#   export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
# fi

if [ "$LIGHTGBM_VERSION" = "" ]; then
  SCRIPT_DIR=`dirname $(realpath "$0")`
  LIGHTGBM_VERSION=`cat $SCRIPT_DIR/../LIGHTGBM_VERSION`
fi

git clone --branch v${LIGHTGBM_VERSION} --depth 1 --recursive https://github.com/microsoft/LightGBM
cd LightGBM

mkdir build
cd build

cmake -DUSE_SWIG=ON -DUSE_OPENMP=OFF -DAPPLE_OUTPUT_DYLIB=ON ..
make -j4

otool -L ../lib_lightgbm.dylib 
otool -L ../lib_lightgbm_swig.jnilib 

mkdir -p assets
mv lightgbmlib.jar assets/lightgbm-$LIGHTGBM_VERSION-osx.jar
