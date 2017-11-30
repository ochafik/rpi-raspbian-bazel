#!/bin/bash
set -eux

git clone https://github.com/ochafik/bazel.git -b from-scratch --depth=1
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
  g++ \
    -I$PROTOC_DIST/include \
    -w -O2 -export-dynamic \
    *.cpp -o protoc-gen-grpc-java \
    $PROTOC_DIST/lib/libproto{c,buf}.a
    -lstdc++
  export GRPC_JAVA_PLUGIN=$PWD/protoc-gen-grpc-java
popd

bash ./compile.sh
