FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        git \
        nasm \
        pkg-config \
        protobuf-compiler \
        python3 \
        python3-pip \
        unzip \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
