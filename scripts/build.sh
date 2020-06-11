export CXX=g++-5 CC=gcc-5
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

git clone --branch v${LIGHTGBM_VERSION} --depth 1 --recursive https://github.com/myui/LightGBM
cd LightGBM

mkdir build
cd build

cmake -DUSE_SWIG=ON -DUSE_OPENMP=OFF -DCMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++ -fvisibility=hidden" ..
make -j4

ldd ../lib_lightgbm.so 
strings ../lib_lightgbm.so  | grep ^GLIBC | sort
