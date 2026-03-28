# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Ramil Safin

ARG CUDNN_SUFFIX=
ARG CUDA_VERSION=12.8.1
ARG UBUNTU_VERSION=24.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_SUFFIX}-devel-ubuntu${UBUNTU_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    ninja-build \
    cmake \
    nano \
    && rm -rf /var/lib/apt/lists/*
