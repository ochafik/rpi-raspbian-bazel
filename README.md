# Bazel on Raspbian

[Bazel](https://bazel.build/) is a Open-Source build tool from Google, which is used to build projects
such as [TensorFlow](https://www.tensorflow.org/). Which is potentially awesome
(if only a bit slow) to use on your shiny new
[Raspberry Pi 3](https://www.raspberrypi.org/) (which one of
[these research models](https://github.com/tensorflow/models/tree/master/research)
 will be the most useful to your next maker project?).

## Why it's not trivial

Unfortunately, Raspbian doesn't have (yet) a package for Bazel. And Bazel
doesn't provide (yet) a binary for armhf. And their instructions to build from
source either implies you have a binary (which we don't) or that you battle with
compilation errors. Which I did in
[ochafik/bazel](https://github.com/ochafik/bazel/tree/from-scratch) (hopefully
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

# Building Bazel

## From sources on a Raspberry Pi

Prerequisite: you'll need a large SD card, and the following packages (assumes
you already have an Oracle JDK8 installed, as is the case on NOOBS distros,
otherwise try `sudo apt-get install default-jdk`):

```bash
sudo apt-get update
sudo apt-get install -y automake g++ libtool make curl git python unzip wget zip
# Reclaim as much space as we can: we'll need it.
sudo apt-get autoremove
sudo apt-get clean
```

Now download my [script](./build_from_scratch.sh) and convince yourself it's safe:
- It clones [ochafik/bazel](https://github.com/ochafik/bazel)
  (my fork of [bazelbuild/bazel](https://github.com/bazelbuild/bazel))
- Either your trust me, or you can fork my fork, check it doesn't contain dodgy
  [diffs against the original repo](https://github.com/bazelbuild/bazel/compare/master...ochafik:from-scratch)
  (assuming you trust the original, which I assume to be the case if you want to
  use Bazel), edit the script to clone your fork instead (in case I sneakily
  modified my fork after you scrutinized it), and proceed to the next command

```bash
wget https://raw.githubusercontent.com/ochafik/rpi-raspbian-bazel/master/build_from_scratch.sh
# Do not trust scripts you download off the net!
less build_from_scratch.sh

bash build_from_scratch.sh
```

## Building the Raspberry Pi Docker image:

We aim to publish images every now and then, but you may rebuild the image at 
any time with the following command (*takes a while*):

```bash
# This only needs to be run once
docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker build -t rpi-raspbian-bazel .
```

### Debugging

If you're debugging things, you might just want to distill the commands from 
[Dockerfile](./Dockerfile) into some interactive container:

```bash
# From the git repo root
docker run --rm -it resin/rpi-raspbian:stretch /bin/bash
```

And if you want to test the `Dockerfile` itself faster on an image that does
not require QEMU:

```bash
docker build -t debian-bazel -f Dockerfile.debian .
```
