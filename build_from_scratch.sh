#!/bin/bash
#
# Builds Bazel from scratch in $PWD/bazel/output/bazel.
# (tested on Raspbian & Debian with Bazel 0.8.0)
#
# Prerequisites:
#   automake g++ libtool make curl git oracle-java8-jdk python unzip wget zip
#
set -eux

git clone https://github.com/ochafik/bazel.git -b build-from-scratch --depth=1
cd bazel

pushd third_party/protobuf/3.4.0
  export PROTOC_DIST=$PWD/dist
  mkdir -p $PROTOC_DIST
  ./autogen.sh
  ./configure --prefix=$PROTOC_DIST
  make install
  export PROTOC=$PROTOC_DIST/bin/protoc
popd

pushd third_party/grpc/compiler/src/java_plugin/cpp
  g++ -std=c++11 \
    -I$PROTOC_DIST/include \
    -w -O2 -export-dynamic \
    *.cpp $PROTOC_DIST/lib/libproto{c,buf}.a \
    -o protoc-gen-grpc-java
  export GRPC_JAVA_PLUGIN=$PWD/protoc-gen-grpc-java
popd

bash ./compile.sh
