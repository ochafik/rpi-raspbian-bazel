# Bazel on Raspbian [![Debian Build Status](https://travis-ci.org/ochafik/rpi-raspbian-bazel.svg?branch=master)](https://travis-ci.org/ochafik/rpi-raspbian-bazel)

*TL;DR* Install bazel on your Raspberry Pi 3 w/ Raspbian "stretch" with:
```bash
wget https://github.com/ochafik/rpi-raspbian-bazel/releases/download/bazel-raspbian-armv7l-0.8.0-20171130/bazel
./bazel
```
Gives:
```
Extracting Bazel installation...
Usage: bazel <command> <options> ...

Available commands:
  analyze-profile     Analyzes build profile data.
  build               Builds the specified targets.
...
```

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
[ochafik/bazel](https://github.com/ochafik/bazel/tree/build-from-scratch) (hopefully
to be pulled back into the original repo), and here I'm using it to build...

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

I've published a [pre-built binary of Bazel ~0.8.0 in the releases section of this repo](https://github.com/ochafik/rpi-raspbian-bazel/releases).

**Use at your own risk, for what I know hackers may have hijacked my Pi and planted viruses in my GCC before I compile this release.**

# Usage

Download a prebuilt-image:
```bash
mkdir ~/bin && echo 'export PATH=$PATH:$HOME/bin' >> ~/.profile
wget -o ~/bin/bazel https://github.com/ochafik/rpi-raspbian-bazel/releases/download/bazel-raspbian-armv7l-0.8.0-20171130/bazel
```
Bazel will extract its files on the first run:
```
bazel
```

# Building Bazel

## From sources on a Raspberry Pi

Prerequisite: you'll need a large SD card (8GB at least), and the following packages:

```bash
sudo apt-get update
sudo apt-get install -y automake g++ libtool make curl git python unzip wget zip
sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

# Reclaim as much space as we can: we'll need it.
sudo apt-get autoremove
sudo apt-get clean
```

Clone [ochafik/bazel](https://github.com/ochafik/bazel) (my fork of
[bazelbuild/bazel](https://github.com/bazelbuild/bazel)) and build it:

```bash
git clone https://github.com/ochafik/bazel -b build-from-scratch --depth=1
cd bazel
bash ./compile.sh
```

# Docker usage (WIP)

```bash
# This only needs to be run once
docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker run --rm -ti ochafik/rpi-raspbian-bazel /bin/bash
# bazel is in the PATH of this container, enjoy!
```

## Building the Raspberry Pi Docker image:

I aim to publish images to docker hub soon, but you may rebuild the image at 
any time with the following command (*takes a while*):

```bash
# This only needs to be run once
docker run --rm --privileged multiarch/qemu-user-static:register --reset

docker build -t rpi-raspbian-bazel .
```

### Debugging it

If you're debugging things, you might just want to distill the commands from 
[Dockerfile](./Dockerfile) into some interactive container:

```bash
# From the git repo root
docker run --rm -it resin/rpi-raspbian:stretch /bin/bash
```

And if you want to test the `Dockerfile` itself faster on an image that does
not require QEMU:

```bash
cat Dockerfile | sed 's/resin\/rpi-raspbian:stretch/debian:stretch/' > Dockerfile.debian
docker build -t debian-bazel-build -f Dockerfile.debian .
```
