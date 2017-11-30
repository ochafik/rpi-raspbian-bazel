# See README.md
#
# This is a multistaged build.
# First, use a full image to build protoc, protoc-gen-grpc-java and bazel.
FROM resin/rpi-raspbian:stretch as builder
RUN apt-get update && \
  apt-get install -y automake g++ libtool make curl git unzip wget zip oracle-java8-jdk && \
  cd / && \
  git clone https://github.com/ochafik/bazel.git -b from-scratch --depth=1 && \
  cd /bazel/third_party/protobuf/3.4.0 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    export PROTOC=$(which protoc) && \
  cd /bazel/third_party/grpc/compiler/src/java_plugin/cpp && \
    g++ \
      -I/usr/local/include \
      -L/usr/local/lib \
      -w -O2 -export-dynamic \
      *.cpp -o protoc-gen-grpc-java \
      -lprotobuf -lprotoc && \
    export GRPC_JAVA_PLUGIN="$PWD/protoc-gen-grpc-java" && \
  cd /bazel && \
  bash ./compile.sh

# Now simply extract the build artefact and sneak it into a slim image.
# Note: we could also copy protoc & protoc-gen-grpc-java.
FROM resin/rpi-raspbian:stretch-slim
COPY --from=builder /bazel/bazel-bin/src/bazel /usr/bin
