# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Ramil Safin

variable "REGISTRY" {
  default = "gs"
}

variable "BASE_NAME" {
  default = "base"
}

target "_common" {
  context    = "."
  dockerfile = "layers/01_base/Dockerfile"
  platforms  = ["linux/amd64"]

  labels = {
    "org.opencontainers.image.title"       = "Gaussian Splatting CUDA base"
    "org.opencontainers.image.description" = "Base CUDA/toolchain image for Gaussian Splatting stacks"
    "org.opencontainers.image.vendor"      = "none"
  }
}

target "cuda_base" {
  inherits = ["_common"]

  matrix = {
    lane = [
      {
        name           = "cu118-ubuntu22"
        cuda_version   = "11.8.0"
        cudnn_suffix   = "8"
        ubuntu_version = "22.04"
      },
      {
        name           = "cu121-ubuntu22"
        cuda_version   = "12.1.1"
        cudnn_suffix   = "8"
        ubuntu_version = "22.04"
      },
      {
        name           = "cu128-ubuntu24"
        cuda_version   = "12.8.1"
        cudnn_suffix   = ""
        ubuntu_version = "24.04"
      },
      {
        name           = "cu130-ubuntu24"
        cuda_version   = "13.0.1"
        cudnn_suffix   = ""
        ubuntu_version = "24.04"
      }
    ]
  }

  name = "base-${lane.name}"

  args = {
    CUDA_VERSION   = lane.cuda_version
    CUDNN_SUFFIX   = lane.cudnn_suffix
    UBUNTU_VERSION = lane.ubuntu_version
  }

  tags = [
    "${REGISTRY}/${BASE_NAME}:${lane.name}"
  ]
}

group "base" {
  targets = ["cuda_base"]
}

group "legacy" {
  targets = [
    "base-cu118-ubuntu22",
    "base-cu121-ubuntu22"
  ]
}

group "modern" {
  targets = [
    "base-cu128-ubuntu24"
  ]
}

group "experimental" {
  targets = [
    "base-cu130-ubuntu24"
  ]
}

group "default" {
  targets = ["base"]
}

variable "TORCH_NAME" {
  default = "torch"
}

target "_torch_common" {
  context    = "."
  dockerfile = "layers/02_torch/Dockerfile"
  platforms  = ["linux/amd64"]

  labels = {
    "org.opencontainers.image.title"       = "Gaussian Splatting Python + PyTorch runtime"
    "org.opencontainers.image.description" = "Python + PyTorch runtime layer for Gaussian Splatting stacks"
    "org.opencontainers.image.vendor"      = "none"
  }
}

target "torch_base" {
  inherits = ["_torch_common"]

  matrix = {
    lane = [
      {
        name                = "py310-torch20-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.0.1"
        torchvision_version = "0.15.2"
        torchaudio_version  = "2.0.2"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py311-torch20-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.0.1"
        torchvision_version = "0.15.2"
        torchaudio_version  = "2.0.2"
        cuda_wheel_index    = "cu118"
      },

      {
        name                = "py310-torch21-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.1.2"
        torchvision_version = "0.16.2"
        torchaudio_version  = "2.1.2"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py311-torch21-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.1.2"
        torchvision_version = "0.16.2"
        torchaudio_version  = "2.1.2"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py310-torch21-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.1.2"
        torchvision_version = "0.16.2"
        torchaudio_version  = "2.1.2"
        cuda_wheel_index    = "cu121"
      },
      {
        name                = "py311-torch21-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.1.2"
        torchvision_version = "0.16.2"
        torchaudio_version  = "2.1.2"
        cuda_wheel_index    = "cu121"
      },

      {
        name                = "py310-torch24-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.4.1"
        torchvision_version = "0.19.1"
        torchaudio_version  = "2.4.1"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py311-torch24-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.4.1"
        torchvision_version = "0.19.1"
        torchaudio_version  = "2.4.1"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py312-torch24-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.12"
        torch_version       = "2.4.1"
        torchvision_version = "0.19.1"
        torchaudio_version  = "2.4.1"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py310-torch24-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.4.1"
        torchvision_version = "0.19.1"
        torchaudio_version  = "2.4.1"
        cuda_wheel_index    = "cu121"
      },
      {
        name                = "py311-torch24-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.4.1"
        torchvision_version = "0.19.1"
        torchaudio_version  = "2.4.1"
        cuda_wheel_index    = "cu121"
      },
      {
        name                = "py312-torch24-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.12"
        torch_version       = "2.4.1"
        torchvision_version = "0.19.1"
        torchaudio_version  = "2.4.1"
        cuda_wheel_index    = "cu121"
      },

      {
        name                = "py310-torch25-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.5.1"
        torchvision_version = "0.20.1"
        torchaudio_version  = "2.5.1"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py311-torch25-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.5.1"
        torchvision_version = "0.20.1"
        torchaudio_version  = "2.5.1"
        cuda_wheel_index    = "cu118"
      },
      {
        name                = "py312-torch25-cu118"
        base_image          = "gs/base:cu118-ubuntu22"
        python_version      = "3.12"
        torch_version       = "2.5.1"
        torchvision_version = "0.20.1"
        torchaudio_version  = "2.5.1"
        cuda_wheel_index    = "cu118"
      },

      {
        name                = "py310-torch25-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.10"
        torch_version       = "2.5.1"
        torchvision_version = "0.20.1"
        torchaudio_version  = "2.5.1"
        cuda_wheel_index    = "cu121"
      },
      {
        name                = "py311-torch25-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.11"
        torch_version       = "2.5.1"
        torchvision_version = "0.20.1"
        torchaudio_version  = "2.5.1"
        cuda_wheel_index    = "cu121"
      },
      {
        name                = "py312-torch25-cu121"
        base_image          = "gs/base:cu121-ubuntu22"
        python_version      = "3.12"
        torch_version       = "2.5.0"
        torchvision_version = "0.20.0"
        torchaudio_version  = "2.5.0"
        cuda_wheel_index    = "cu121"
      },

      {
        name                = "py310-torch211-cu128"
        base_image          = "gs/base:cu128-ubuntu24"
        python_version      = "3.10"
        torch_version       = "2.11.0"
        torchvision_version = "0.26.0"
        torchaudio_version  = "2.11.0"
        cuda_wheel_index    = "cu128"
      },
      {
        name                = "py311-torch211-cu128"
        base_image          = "gs/base:cu128-ubuntu24"
        python_version      = "3.11"
        torch_version       = "2.11.0"
        torchvision_version = "0.26.0"
        torchaudio_version  = "2.11.0"
        cuda_wheel_index    = "cu128"
      },
      {
        name                = "py312-torch211-cu128"
        base_image          = "gs/base:cu128-ubuntu24"
        python_version      = "3.12"
        torch_version       = "2.11.0"
        torchvision_version = "0.26.0"
        torchaudio_version  = "2.11.0"
        cuda_wheel_index    = "cu128"
      },

      {
        name                = "py310-torch211-cu130"
        base_image          = "gs/base:cu130-ubuntu24"
        python_version      = "3.10"
        torch_version       = "2.11.0"
        torchvision_version = "0.26.0"
        torchaudio_version  = "2.11.0"
        cuda_wheel_index    = "cu130"
      },
      {
        name                = "py311-torch211-cu130"
        base_image          = "gs/base:cu130-ubuntu24"
        python_version      = "3.11"
        torch_version       = "2.11.0"
        torchvision_version = "0.26.0"
        torchaudio_version  = "2.11.0"
        cuda_wheel_index    = "cu130"
      },
      {
        name                = "py312-torch211-cu130"
        base_image          = "gs/base:cu130-ubuntu24"
        python_version      = "3.12"
        torch_version       = "2.11.0"
        torchvision_version = "0.26.0"
        torchaudio_version  = "2.11.0"
        cuda_wheel_index    = "cu130"
      }
    ]
  }

  name = "torch-${lane.name}"

  args = {
    BASE_IMAGE          = lane.base_image
    PYTHON_VERSION      = lane.python_version
    TORCH_VERSION       = lane.torch_version
    TORCHVISION_VERSION = lane.torchvision_version
    TORCHAUDIO_VERSION  = lane.torchaudio_version
    CUDA_WHEEL_INDEX    = lane.cuda_wheel_index
  }

  tags = [
    "${REGISTRY}/${TORCH_NAME}:${lane.name}"
  ]
}

group "torch" {
  targets = ["torch_base"]
}

group "torch_legacy" {
  targets = [
    "torch-py310-torch20-cu118",
    "torch-py311-torch20-cu118",
    "torch-py310-torch21-cu118",
    "torch-py311-torch21-cu118",
    "torch-py310-torch21-cu121",
    "torch-py311-torch21-cu121",
    "torch-py310-torch25-cu118",
    "torch-py311-torch25-cu118",
    "torch-py312-torch25-cu118",
  ]
}

group "torch_transition" {
  targets = [
    "torch-py310-torch24-cu118",
    "torch-py311-torch24-cu118",
    "torch-py312-torch24-cu118",
    "torch-py310-torch24-cu121",
    "torch-py311-torch24-cu121",
    "torch-py312-torch24-cu121",
    "torch-py310-torch25-cu121",
    "torch-py311-torch25-cu121",
    "torch-py312-torch25-cu121",
  ]
}

group "torch_modern" {
  targets = [
    "torch-py310-torch211-cu128",
    "torch-py311-torch211-cu128",
    "torch-py312-torch211-cu128",
  ]
}

group "torch_experimental" {
  targets = [
    "torch-py310-torch211-cu130",
    "torch-py311-torch211-cu130",
    "torch-py312-torch211-cu130",
  ]
}