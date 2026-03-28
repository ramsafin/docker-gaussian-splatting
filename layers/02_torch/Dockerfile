# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Ramil Safin

ARG BASE_IMAGE=gs/base:cu128-ubuntu24
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    MAMBA_ROOT_PREFIX=/opt/micromamba \
    ENV_NAME=pyenv

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG PYTHON_VERSION=3.10
ARG TORCH_VERSION=2.11.0
ARG TORCHVISION_VERSION=0.26.0
ARG TORCHAUDIO_VERSION=2.11.0
ARG CUDA_WHEEL_INDEX=cu128

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    bzip2 \
    && rm -rf /var/lib/apt/lists/*

RUN wget --no-check-certificate -O /tmp/micromamba.tar.bz2 \
    https://micro.mamba.pm/api/micromamba/linux-64/latest \
 && tar -xvjf /tmp/micromamba.tar.bz2 -C /tmp bin/micromamba \
 && mv /tmp/bin/micromamba /usr/local/bin/micromamba \
 && chmod +x /usr/local/bin/micromamba \
 && rm -rf /tmp/micromamba.tar.bz2 /tmp/bin

RUN micromamba create -y -n "${ENV_NAME}" python="${PYTHON_VERSION}" pip \
 && micromamba clean --all --yes

ENV PATH=/opt/micromamba/envs/${ENV_NAME}/bin:${PATH}

RUN python --version \
 && pip install --no-cache-dir --upgrade pip setuptools wheel \
 && pip install --no-cache-dir \
      "torch==${TORCH_VERSION}" \
      "torchvision==${TORCHVISION_VERSION}" \
      "torchaudio==${TORCHAUDIO_VERSION}" \
      --index-url "https://download.pytorch.org/whl/${CUDA_WHEEL_INDEX}"
