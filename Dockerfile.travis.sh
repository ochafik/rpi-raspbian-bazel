FROM resin/rpi-raspbian:stretch
ADD build_from_scratch.sh /
RUN apt-get update && \
  apt-get install -y automake default-jdk g++ libtool make curl git python unzip wget zip && \
  cd / && \
  bash /build_from_scratch.sh
