#!/bin/bash
set -eux

git clone https://github.com/ochafik/bazel.git -b from-scratch --depth=1
cd bazel

pushd third_party/protobuf/3.4.0
  ./autogen.sh
  ./configure
  make
  # TODO(ochafik): do without this (how to link protoc-gen-grpc-java below?)
  sudo make install
  sudo ldconfig
  export PROTOC=$(which protoc)
popd

pushd third_party/grpc/compiler/src/java_plugin/cpp
  g++ \
    -I/usr/local/include \
    -L/usr/local/lib \
    -w -O2 -export-dynamic \
    *.cpp -o protoc-gen-grpc-java \
  -lprotobuf -lprotoc
  export GRPC_JAVA_PLUGIN="$PWD/protoc-gen-grpc-java"
popd

bash ./compile.sh
