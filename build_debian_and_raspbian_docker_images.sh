#!/bin/bash
set -eux

if [[ ! -d dist-amd64 ]]; then
  cat Dockerfile | sed 's/resin\/rpi-raspbian:stretch/debian:stretch/' > Dockerfile.debian
  docker build -t debian-bazel-build -f Dockerfile.debian .

  mkdir dist-amd64
  id=$(docker create debian-bazel-build)
  docker cp $id:bazel/output/bazel dist-amd64
  docker rm -v $id
  echo "
  FROM debian-bazel-build
  COPY ./dist-amd64/bazel /usr/bin
  " > Dockerfile.debian-slim
  docker build -t debian-bazel -f Dockerfile.debian-slim .
fi

if [[ ! -d dist-armhf ]]; then
  docker build -t rpi-raspbian-bazel-build .
  mkdir dist-armhf
  id=$(docker create rpi-raspbian-bazel-build)
  docker cp $id:bazel/output/bazel dist-armhf
  docker rm -v $id
  echo "
  FROM rpi-raspbian-bazel-build
  COPY ./dist-armhf/bazel /usr/bin
  " > Dockerfile.raspbian-slim
  docker build -t rpi-raspbian-bazel -f Dockerfile.raspbian-slim .
fi