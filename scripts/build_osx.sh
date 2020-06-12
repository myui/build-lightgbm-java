# if [ -z "${JAVA_HOME+UNDEF}" ];then
#   export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
# fi

git clone --branch v${LIGHTGBM_VERSION} --depth 1 --recursive https://github.com/microsoft/LightGBM
cd LightGBM

mkdir build
cd build

cmake -DUSE_SWIG=ON -DUSE_OPENMP=OFF -DAPPLE_OUTPUT_DYLIB=ON ..
make -j4

otool -L ../lib_lightgbm.dylib 
otool -L ../lib_lightgbm_swig.jnilib 

mv lightgbmlib.jar $TRAVIS_BUILD_DIR/lightgbm-$LIGHTGBM_VERSION-$TRAVIS_OS_NAME-$TRAVIS_DIST.jar
