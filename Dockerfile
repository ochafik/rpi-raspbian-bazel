# See README.md
#
# This is a multistaged build.
# First, use a full image to build protoc, protoc-gen-grpc-java and bazel.
FROM resin/rpi-raspbian:stretch as builder
ADD build_from_scratch.sh /
RUN apt-get update && \
  apt-get install -y automake default-jdk g++ libtool make curl git python unzip wget zip && \
  cd / && \
  bash /build_from_scratch.sh

# Now simply extract the build artefact and sneak it into a slim image.
# Note: we could also copy protoc & protoc-gen-grpc-java.
FROM resin/rpi-raspbian:stretch-slim
COPY --from=builder /bazel/bazel-bin/src/bazel /usr/bin
