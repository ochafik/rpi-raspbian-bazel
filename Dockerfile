# See README.md
FROM resin/rpi-raspbian:stretch
ADD build_from_scratch.sh /

RUN apt-get update

# Needed for apt-key on the debian:stretch image.
RUN apt-get install -y gnupg

# Note: installs Oracle's JDK8, as the OpenJDK crashes in QEMU during the build.
# RUN apt-get update && apt-get install -y default-jdk
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | \
    tee /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -y oracle-java8-installer oracle-java8-set-default

RUN apt-get install -y automake g++ libtool make curl git python unzip wget zip && \
  apt-get autoremove && \
  apt-get clean

RUN cd / && bash ./build_from_scratch.sh
