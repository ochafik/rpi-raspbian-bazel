# Bazel on Raspbian

## On Docker

In case you didn't know, you can run a Raspberry Pi (emulator) Docker container 
on your desktop with little to no effort ([this post from resin.io]
(https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/)
explains the magic they've written to pull this off).

This repo builds a Bazel-ready Docker image based on
[resin/rpi-raspbian](https://hub.docker.com/r/resin/rpi-raspbian/)
(which is managed by [resin.io](https://resin.io) whom I have no
affiliation with).

## On a Raspberry Pi

The plan is to also package the resulting `bazel` binary as a `.deb`.
TODO: add release `.deb` for armhf

# Usage

```bash
# This only needs to be run once
docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker run --rm -ti ochafik/rpi-raspbian-bazel
# bazel is in the PATH!
```

# Re-building the Raspberry Pi image:

We aim to publish images every now and then, but you may rebuild the image at 
any time with the following command (*takes a while*):

```bash
# This only needs to be run once
docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker build -t rpi-raspbian-bazel .
```

## Debugging

If you're debugging things, you might just want to distill the commands from 
[./Dockerfile] into some image that does not require QEMU:

```bash
# From the git repo root
docker run --rm -it -v `pwd`:/bazel -w `pwd` resin/rpi-raspbian:stretch /bin/bash
# cd /bazel
```

And if you want to test the `Dockerfile` itself faster, retarget it to some
image that does not require QEMU:

```bash
cat Dockerfile | \
  sed 's/resin\/rpi-raspbian:stretch/debian:stable/g' | \
  docker build -t rpi-raspbian-bazel-debian -
```
