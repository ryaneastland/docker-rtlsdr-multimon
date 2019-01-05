# derive from our baseimage
FROM envoi/rtlsdr-base:latest

RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs

MAINTAINER Anton S. <anton@env.sh>
LABEL Description="RTLSDR Multimon-ng in Docker"
LABEL Vendor="Envoi"
LABEL Version="0.0.1"

RUN apt-get update \
&& apt-get install -y --no-install-recommends qt4-qmake libpulse-dev libx11-dev lighttpd \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN ldconfig

RUN git clone --depth 1 --progress git://github.com/ryaneastland/multimon-ng.git /tmp/multimon-ng

RUN mkdir /tmp/multimon-ng/build

WORKDIR /tmp/multimon-ng/build
RUN qmake ../multimon-ng.pro PREFIX=/usr/local
RUN make
RUN make install

RUN git clone https://github.com/ryaneastland/pagermon.git /pagermon

WORKDIR /pagermon/client

RUN npm install
