FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
  ca-certificates \
  dbus \
  libcanberra-gtk-module \
  libcanberra-gtk3-module \
  libasound2 \
  libgconf-2-4 \
  libgtk2.0-0 \
  libnss3 \
  libxss1 \
  libxtst6 \
  libx11-xcb1 \
  locales \
  unzip \
  wget \
  --no-install-recommends

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

WORKDIR /root

COPY sha256checksum .

RUN wget https://github.com/ethereum/mist/releases/download/v0.11.1/Mist-linux64-0-11-1.zip && \
  sha256sum -c sha256checksum && \
  unzip Mist-linux64-0-11-1.zip -d mist && \
  rm Mist-linux64-0-11-1.zip

WORKDIR /root/mist

EXPOSE 8545

ENTRYPOINT ["./mist"]
