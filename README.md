# Bazel on Raspbian [![Debian Build Status](https://travis-ci.org/ochafik/rpi-raspbian-bazel.svg?branch=master)](https://travis-ci.org/ochafik/rpi-raspbian-bazel)

*TL;DR* Install bazel on your Raspberry Pi 3 w/ Raspbian "stretch" with:
```bash
wget https://github.com/ochafik/rpi-raspbian-bazel/releases/download/bazel-raspbian-armv7l-0.8.0-20171130/bazel
chmod +x ./bazel
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

## The problem...

Edit: as pointed out in [this PR](https://github.com/bazelbuild/bazel/pull/4199#issuecomment-348571809), Bazel releases have a "distribution" `-dist.zip` archive zip that contains pregenerated Java artefacts for its proto files (which I overlooked in the [doc](https://docs.bazel.build/versions/master/install-compile-source.html)).

The problem I tried to solve is to build from the git tree, not from the distribution zip (which makes it much easier).

Credits: I've spent time absorbing https://github.com/samjabrahams/tensorflow-on-raspberry-pi, who tried to solve the same issue + build Tensorflow on the Pi, but probably for an earlier version of Bazel.

Unfortunately, Raspbian doesn't have (yet) a package for Bazel. And Bazel
doesn't provide (yet) a binary for armhf. And their instructions to build from
source requires you use their distribution archive, ruling out git source tree 
as the _"archive contains generated files in addition to the versioned sources, so this step cannot be short cut by checking out the source tree."_.

I tried to prove this assumption wrong in
[ochafik/bazel](https://github.com/ochafik/bazel/tree/build-from-scratch) (hopefully
to be pulled back into the original repo), and here I'm using it to build...

## Raspberry Pi binaries

I've published a [pre-built binary of Bazel ~0.8.0 in the releases section of this repo](https://github.com/ochafik/rpi-raspbian-bazel/releases).

**Use at your own risk, for what I know hackers may have hijacked my Pi and planted viruses in my GCC before I compile this release.**

# Usage

Download a prebuilt-image:
```bash
mkdir ~/bin && echo 'export PATH=$PATH:$HOME/bin' >> ~/.profile
wget -o ~/bin/bazel https://github.com/ochafik/rpi-raspbian-bazel/releases/download/bazel-raspbian-armv7l-0.8.0-20171130/bazel
chmod +x ~/bin/bazel
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

Clone [ochafik/bazel](https://github.com/ochafik/bazel/tree/build-from-scratch) (my fork of
[bazelbuild/bazel](https://github.com/bazelbuild/bazel)) and build it:

```bash
git clone https://github.com/ochafik/bazel -b build-from-scratch --depth=1
cd bazel
bash ./compile.sh
```
