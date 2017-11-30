#!/bin/bash
set -eux

readonly BAZEL_OUTPUT=/bazel/output/bazel

function build_bazel_docker() {
  local build_image_base="$1"
  local build_image_name="$2"
  local normal_image_base="$3"
  local normal_image_name="$4"
  local slim_image_base="$5"
  local slim_image_name="$6"
  local dist_dir="$7"

  if [[ ! -d "$dist_dir" ]]; then
    cat Dockerfile | \
      sed "s/resin\/rpi-raspbian:stretch/$(echo "$build_image_base" | sed 's/\//\\\//g')/" |
      docker build -t "$build_image_name" -

    mkdir -p "$dist_dir"
    id=$(docker create "$build_image_name")
    docker cp "$id:$BAZEL_OUTPUT" "$dist_dir"
    docker rm -v $id

    echo "
      FROM $normal_image_base
      COPY ./$dist_dir/bazel /usr/bin
    " | \
      docker build -t "$normal_image_name" -

    echo "
      FROM $slim_image_base
      COPY ./$dist_dir/bazel /usr/bin
    " | \
      docker build -t "$slim_image_name" -
  fi
}

# Use native Debian as a canary of sorts: this will fail way faster than the
# QEMU rasbian build.
build_bazel_docker \
  debian:stretch      debian-bazel-build \
  debian:stretch      debian-bazel \
  debian:stretch-slim debian-bazel-slim \
  dist-amd64

build_bazel_docker \
  resin/rpi-raspbian:stretch      rpi-raspbian-bazel-build \
  resin/rpi-raspbian:stretch      rpi-raspbian-bazel \
  resin/rpi-raspbian:stretch-slim rpi-raspbian-bazel-slim \
  dist-armhf
