# Bazel on Raspian

This is an off-the-shelf Bazel-ready Docker image based on
[resin/rpi-raspbian](https://hub.docker.com/r/resin/rpi-raspbian/)
(which is managed by [resin.io](https://resin.io), with whom I have no
affiliation).

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

And if you want to test the `Dockerfile` itself, just retarget it for `debian`
as follows:

```bash
cat Dockerfile | \
  sed 's/resin\/rpi-raspbian:stretch/debian:stable/g' | \
  docker build -t rpi-raspbian-bazel-debian -
```
