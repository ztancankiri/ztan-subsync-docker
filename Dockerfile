FROM python:3.8-slim-buster

ARG DEBIAN_FRONTEND=noninteractive
ARG CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    apt-utils gcc g++ build-essential libssl-dev libffi-dev \
    git curl swig libpulse-dev libasound2-dev  \
    libsphinxbase3 libsphinxbase-dev \
    libpocketsphinx-dev libavdevice-dev \
    libdrm-dev libxcb1-dev libgl-dev \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /build \
    && cd /build \
    && python -m pip install -U pip \
    && git clone https://github.com/sc0ty/subsync.git \
    && cd subsync \
    && cp subsync/config.py.template subsync/config.py \
    && pip install --no-binary :all: "cryptography<3.5" \
    && pip install .

RUN mv /build/subsync/bin/portable /subsync && \
    rm -rf /build

RUN pip install guessit
