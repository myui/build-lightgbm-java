#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset
# Exit script if a statement returns a non-true return value.
set -o errexit

# export CXX=g++-5 CC=gcc-5
# export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

if [ "$LIGHTGBM_VERSION" = "" ]; then
  SCRIPT_DIR=`dirname $(readlink -f $0)`
  LIGHTGBM_VERSION=`cat $SCRIPT_DIR/../LIGHTGBM_VERSION`
fi

git clone --branch v${LIGHTGBM_VERSION} --depth 1 --recursive https://github.com/microsoft/LightGBM
cd LightGBM

mkdir build
cd build

cmake -DUSE_SWIG=ON -DUSE_OPENMP=OFF -DCMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++ -fvisibility=hidden" ..
make -j4

echo "Show information about lib_lightgbm.so ..."
ldd ../lib_lightgbm.so 
strings ../lib_lightgbm.so  | grep ^GLIBC | sort
echo
echo "Show information about lib_lightgbm_swig.so ..."
ldd ../lib_lightgbm_swig.so
strings ../lib_lightgbm_swig.so  | grep ^GLIBC | sort

cp lightgbmlib.jar lightgbmlib-sources.jar
mv java/*.java com/microsoft/ml/lightgbm/
jar uf lightgbmlib-sources.jar com/microsoft/ml/lightgbm/*.java
# jar tf lightgbmlib-sources.jar

javadoc -classpath lightgbmlib-sources.jar -d javadoc com.microsoft.ml.lightgbm
jar cvf lightgbmlib-javadoc.jar -C javadoc/ .

mkdir -p assets
mv lightgbmlib.jar assets/lightgbm-$LIGHTGBM_VERSION.jar
mv lightgbmlib-sources.jar assets/lightgbm-$LIGHTGBM_VERSION-sources.jar
mv lightgbmlib-javadoc.jar assets/lightgbm-$LIGHTGBM_VERSION-javadoc.jar
ls -al assets/
