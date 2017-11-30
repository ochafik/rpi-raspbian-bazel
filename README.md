# Bazel on Raspbian

Bazel is a Open-Source build tool from Google, which is used to build projects
such as TensorFlow. Which is potentially so cool (if a bit slow) to use on your
shiny Raspberry Pi 3!

Unfortunately, Raspbian doesn't have (yet) a package for Bazel. And Bazel
doesn't provide (yet) a binary for armhf. And their instructions to build from
source either implies you have a binary (which we don't) or that you battle with
compilation errors. Which I did in
[ochafik/bazel](https://github.com/ochafik/bazel/blob/from-scratch) (hopefully
to be merged back into the original repo), and here I'm using it to build...

## A Docker image to run Raspbian w/ Bazel on your Desktop

In case you didn't know, you can run a Raspberry Pi (emulator) Docker container 
on your desktop with little to no effort ([this post](https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) on resin.io
explains the magic they've written to pull this off).

This repo builds a Bazel-ready Docker image based on
[resin/rpi-raspbian](https://hub.docker.com/r/resin/rpi-raspbian/)
(which is managed by [resin.io](https://resin.io) whom I have no
affiliation with).

and...

## Raspberry Pi binaries

The plan is to also package the resulting `bazel` binary as a `.deb`.

TODO: add release `.deb` for armhf

# Usage

```bash
# This only needs to be run once
docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker run --rm -ti ochafik/rpi-raspbian-bazel /bin/bash
# bazel is in the PATH of this container, enjoy!
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
docker run --rm -it resin/rpi-raspbian:stretch /bin/bash
```

And if you want to test the `Dockerfile` itself faster, retarget it to some
image that does not require QEMU:

```bash
cat Dockerfile | \
  sed 's/resin\/rpi-raspbian:stretch/debian:stable/g' | \
  docker build -t debian-bazel -
```
