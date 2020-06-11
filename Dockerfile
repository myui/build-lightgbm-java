#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM ubuntu:precise
MAINTAINER Makoto Yui <myui@apache.org>

ENV LIGHTGBM_VERSION=2.3.1

WORKDIR /work

COPY ./scripts/build.sh .

RUN set -eux && \
    apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
	add-apt-repository -y ppa:roblib/ppa && \
	add-apt-repository -y ppa:git-core/ppa && \
	add-apt-repository -y ppa:george-edison55/precise-backports && \
	add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
	apt-get update && \
	apt-get install -y vim maven wget binutils git g++-5 openjdk-7-jdk make cmake libpthread-stubs0-dev swig && \
	export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 && \
	update-alternatives --install `which java` java ${JAVA_HOME}/bin/java 1062 && \
	rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /root/.m2/*

VOLUME ["/tmp", "/mnt/host/tmp"]

CMD ["bash"]