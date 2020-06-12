# build-lightgbm-jvm
[![Build Status](https://travis-ci.org/myui/build-lightgbm-jvm.svg?branch=master)](https://travis-ci.org/myui/build-lightgbm-jvm) 
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/io.github.myui/lightgbm/badge.svg)](https://search.maven.org/#search%7Cga%7C1%7Cg%3A%22io.github.myui%22%20a%3Alightgbm) 
[![License](http://img.shields.io/:license-Apache_v2-blue.svg)](https://github.com/myui/build-lightgbm-jvm/blob/master/LICENSE)

Repository to build Java LightGBM package for Linux/MacOSX. 

When pushing a tag to git, TravisCI automatically creates a release.

# Using lightgbm

This project publishes lightgbm to Maven central that contains portable binaries for MacOSX and Linux. 

```
<dependency>
    <groupId>io.github.myui</groupId>
    <artifactId>lightgbm</artifactId>
    <version>2.3.1-rc1</version>
</dependency>
```

# Portability

# Update shared library in jar

```sh
$ jar uf lightgbm-2.3.1-rc1.jar com/microsoft/ml/lightgbm/osx/x86_64/lib_lightgbm.dylib
$ jar uf lightgbm-2.3.1-rc1.jar com/microsoft/ml/lightgbm/osx/x86_64/lib_lightgbm_swig.dylib

$ jar tf lightgbm-2.3.1-rc1.jar | grep lib_lightgbm
com/microsoft/ml/lightgbm/linux/x86_64/lib_lightgbm.so
com/microsoft/ml/lightgbm/linux/x86_64/lib_lightgbm_swig.so
com/microsoft/ml/lightgbm/osx/x86_64/lib_lightgbm.dylib
com/microsoft/ml/lightgbm/osx/x86_64/lib_lightgbm_swig.dylib
```

Compilied shared libraries (i.e., liblightgbm.dylib|so) are a portable one without dependencies to openmp and libc++ (for linux) as follows:
Minimum requirement for GLIBC is [2.15](https://abi-laboratory.pro/tracker/timeline/glibc/).

```sh
$ otool -L com/microsoft/ml/lightgbm/osx/x86_64/*.dylib

com/microsoft/ml/lightgbm/osx/x86_64/lib_lightgbm.dylib:
	@rpath/lib_lightgbm.dylib (compatibility version 0.0.0, current version 0.0.0)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 400.9.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.50.4)
com/microsoft/ml/lightgbm/osx/x86_64/lib_lightgbm_swig.dylib:
	@rpath/lib_lightgbm.dylib (compatibility version 0.0.0, current version 0.0.0)
	/usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 400.9.0)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1252.50.4)

$ ldd com/microsoft/ml/lightgbm/linux/x86_64/*.so
com/microsoft/ml/lightgbm/linux/x86_64/lib_lightgbm.so:
	linux-vdso.so.1 =>  (0x00007ffeec362000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fb62c72d000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fb62c510000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fb62c14f000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fb62cf6c000)
com/microsoft/ml/lightgbm/linux/x86_64/lib_lightgbm_swig.so:
	linux-vdso.so.1 =>  (0x00007ffe70bca000)
	lib_lightgbm.so => not found
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fd1ae051000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fd1adc90000)
	/lib64/ld-linux-x86-64.so.2 (0x00007fd1ae482000)

$ strings com/microsoft/ml/lightgbm/linux/x86_64/*.so | grep ^GLIBC | sort | uniq
GLIBC_2.14
GLIBC_2.2.5
GLIBC_2.3
GLIBC_2.3.2
GLIBC_2.3.4
GLIBC_2.4
```
 
You can find requirements in your environment by `strings /lib/x86_64-linux-gnu/libc.so.6 | grep ^GLIBC | sort`.

# Release to Maven central

## Release to Staging

```sh
export NEXUS_PASSWD=xxxx
export LIGHTGBM_VERSION=2.3.1
export RC_NUMBER=1

mvn gpg:sign-and-deploy-file \
  -s ./settings.xml \
  -DpomFile=./lightgbm.pom \
  -DrepositoryId=sonatype-nexus-staging \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
  -Dfile=dist/lightgbm-${LIGHTGBM_VERSION}-rc${RC_NUMBER}.jar \
  -Dsources=dist/lightgbm-${LIGHTGBM_VERSION}-rc${RC_NUMBER}-sources.jar \
  -Djavadoc=dist/lightgbm-${LIGHTGBM_VERSION}-rc${RC_NUMBER}-javadoc.jar
```

## Release from Staging

1. Log in to [oss.sonatype.com](https://oss.sonatype.org/)
2. Click on “Staging Repositories” under Build Promotion
3. Verify the content of the repository (in the bottom pane), check it, click Close, confirm
4. Check the repo again, click “Release”
5. You shall now see your artifacts in the release repository created for you
6. In some hours, it should also appear in Maven Central
