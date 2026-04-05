# Gaussian Splatting Docker Images

Docker images for Gaussian Splatting with CUDA support.

## Prerequisites

- Docker (version `29.x.x+`)
- Docker Buildx (for multi-platform builds)
- NVIDIA Container Toolkit (for GPU support)

Verify NVIDIA Container Toolkit is installed:

```bash
nvidia-container-toolkit --version
```

## Image Structure

The images are built in layers to optimize caching and reusability:

| Layer | Description | Base Image |
|-------|-------------|------------|
| **CUDA Base** | CUDA runtime and development tools | NVIDIA CUDA |
| **PyTorch Base** | PyTorch with CUDA support | CUDA Base |
| **Gaussian Splatting** | Full Gaussian Splatting environment | PyTorch Base |

## Building Images

### Using Docker Buildx Bake

All images are built using `docker buildx bake` with a `docker-bake.hcl` configuration file.

#### 1. Build CUDA Base Images

These images provide the CUDA foundation:

```bash
# Build all base images
docker buildx bake --load base

# Build specific CUDA version
docker buildx bake --load base-cu128-ubuntu24
```

Available CUDA base variants:

- `base-cu118-ubuntu22` - CUDA 11.8 on Ubuntu 22.04
- `base-cu121-ubuntu22` - CUDA 12.1 on Ubuntu 22.04
- `base-cu124-ubuntu22` - CUDA 12.4 on Ubuntu 22.04
- `base-cu128-ubuntu24` - CUDA 12.8 on Ubuntu 24.04

#### 2. Build PyTorch Base Images

These images add PyTorch with CUDA support:

```bash
# Build all PyTorch base images
docker buildx bake --load pytorch-base

# Build specific PyTorch version
docker buildx bake --load pytorch-py310-torch25-cu118
```

#### 3. Build Gaussian Splatting Images (WIP)

Gaussian Splatting env with all deps:

```bash
# Build all Gaussian Splatting images
docker buildx bake --load gs

# Build specific variant (example)
docker buildx bake --load local-dygs-py310-torch25-cu118
```

### Using the Build Script

For convenience, a build script is provided:

```bash
# Make the script executable
chmod +x build-images.sh

./build-images.sh

# Build specific target
./build-images.sh --target torch-py310-torch25-cu118

# Build with verbose output
./build-images.sh --verbose
```

## Running Containers

### Basic GPU Container

```bash
docker run --gpus all -it gs/torch:py310-torch211-cu130
```

### Mount Local Directory

```bash
docker run --gpus all \
  -v $(pwd):/workspace \
  -it gs/torch:py310-torch211-cu130
```

### GUI support (Visualization)

```bash
xhost +local:docker

docker run --gpus all \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -it gs/torch:py310-torch211-cu130
```

## Development

### Adding New Build Targets

Edit `docker-bake.hcl` to add new targets:

```hcl
target "my-custom-target" {
  inherits = ["base"]
  dockerfile = "path/to/Dockerfile"
  tags = ["gs/your:tag"]
  args = {
    PYTORCH_VERSION = "2.1.0",
    CUDA_VERSION = "12.1",
  }
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

SPDX-License-Identifier: MIT
