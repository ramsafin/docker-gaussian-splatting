# Support Matrix

This document defines the compatibility model for the Gaussian Splatting Docker image stack.

It defines:

1. **Official upstream support**
   - what PyTorch officially supports
   - what CUDA base images exist upstream

2. **Maintained image lanes**
   - which CUDA / Python / PyTorch combinations are built in this repository

3. **Project-level compatibility**
   - additional constraints required by specific Gaussian Splatting repositories

Layers:

- Layer 1: CUDA base
- Layer 2: Python + PyTorch runtime
- Layer 3: project overlay

---

## 1. Compatibility Model

This repository does **not** attempt to build the full Cartesian product of:

- CUDA
- Ubuntu
- Python
- PyTorch
- project-specific Python dependencies

Instead, it defines a small set of **compatibility lanes**.

A compatibility lane is a validated combination of:

- CUDA base image
- Ubuntu version
- Python version
- PyTorch version
- optional dependency constraints

---

## 2. Official PyTorch Compatibility

| PyTorch | Python | Stable CUDA | Experimental CUDA | Notes |
|---|---|---|---|---|
| `2.11`     | `>=3.10, <=3.14` | `12.6`, `12.8`, `13.0`  | none   | `13.0` becomes stable |
| `2.10–2.9` | `>=3.10, <=3.14` | `12.6`, `12.8`          | `13.0` | modern CUDA family |
| `2.8`      | `>=3.9, <=3.13`  | `12.6`, `12.8`          | `12.9` | transition before `13.0` experimental |
| `2.7`      | `>=3.9, <=3.13`  | `11.8`, `12.6`          | `12.8` | mixed legacy/modern CUDA |
| `2.6`      | `>=3.9, <=3.13`  | `11.8`, `12.4`          | `12.6` | transition from `11.8` / `12.4` |
| `2.5`      | `>=3.9, <=3.12`  | `11.8`, `12.1`, `12.4`  | none   | broad stable support |
| `2.4`      | `>=3.8, <=3.12`  | `11.8`, `12.1`          | `12.4` | bridge release |
| `2.3–2.1`  | `>=3.8, <=3.11`  | `11.8`                  | `12.1` | main legacy 2.x family |
| `2.0`      | `>=3.8, <=3.11`  | `11.7`                  | `11.8` | older 2.x baseline |

Reference: [PyTorch release compatibility matrix](https://github.com/pytorch/pytorch/blob/main/RELEASE.md)

For Docker image design, the PyTorch releases above can be viewed as a few larger families:

| Family | PyTorch versions | Notes |
|---|---|---|
| Early 2.x legacy     | `2.0–2.3`  | important for older repos and older deps |
| Mid 2.x transitional | `2.4–2.7`  | broad compat range, useful for migration and mixed envs |
| Modern 2.x           | `2.8–2.11` | preferred family for newer CUDA stacks and GPU gens |

---

## 3. Maintained CUDA Lanes (Layer 1)

**Layer 1** defines the maintained CUDA base images used by the rest of the stack.

These lanes are intentionally limited to a small, practical subset that covers legacy, 
transition, modern, and future-oriented setups without making the matrix unnecessarily large.

| Lane | NVIDIA CUDA image | Notes |
|---|---|---|
| `cu118` (11.8) | `nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04` | legacy compat lane |
| `cu121` (12.1) | `nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04` | transition compat lane |
| `cu128` (12.8) | `nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04`  | main modern lane |
| `cu130` (13.0) | `nvidia/cuda:13.0.1-cudnn-devel-ubuntu24.04`  | future-use lane for newer PyTorch stacks |

Reference: [NVIDIA CUDA container catalog](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda)

### Output Image Tags

Each maintained CUDA lane produces a corresponding **Layer 1 base image**:

| Lane | Output image |
|---|---|
| `cu118` | `gs/base:cu118-ubuntu22` |
| `cu121` | `gs/base:cu121-ubuntu22` |
| `cu128` | `gs/base:cu128-ubuntu24` |
| `cu130` | `gs/base:cu130-ubuntu24` |

---

## 4. Supported Python Versions

**Layer 2** builds on the CUDA base images and defines the primary Python versions used across the stack.  

The maintained Python set is intentionally small and covers legacy-compatible, balanced, and modern environments.

| Python         | Notes                        |
| -------------- | ---------------------------- |
| `py310` (3.10) | best legacy-to-modern bridge |
| `py311` (3.11) | safe middle lane             |
| `py312` (3.12) | modern default               |

### CUDA + Python Base Matrix

All maintained CUDA lanes can be combined with all maintained Python lanes at the **base-image level**.

| CUDA      | `py310` | `py311` | `py312` | Role                   |
| --------- | ------: | ------: | ------: | ---------------------- |
| `cu118`   |      +  |      +  |      +  | legacy compat lane     |
| `cu121`   |      +  |      +  |      +  | transition compat lane |
| `cu128`   |      +  |      +  |      +  | main modern lane       |
| `cu130`   |      +  |      +  |      +  | future-use lane        |

**Note:** this table describes **CUDA + Python base-image combinations** only.
PyTorch support is more restrictive and must be validated separately at the PyTorch lane level.

---

## 5. Maintained Python + PyTorch Lanes (Layer 2)

Layer 2 defines the maintained Python + PyTorch runtime images built on top of the CUDA base lanes.

The maintained PyTorch set is intentionally small and is designed to cover legacy, transition, modern,
and future-oriented environments without inflating the matrix.

| PyTorch  | Version | Notes |
| -------- | ------- | ----- |
| `torch20`  | 2.0.x   | legacy GS compatibility, OpenMMLab 3.0-3.2 support |
| `torch21`  | 2.1.x   | legacy GS compatibility, OpenMMLab 3.2+ support |
| `torch24`  | 2.4.x   | transitional lane, 2024 project target |
| `torch25`  | 2.5.x   | transition-era lane, broad stable support |
| `torch211` | 2.11.x  | modern + future lane for `cu128` and `cu130` |

### CUDA + Python + PyTorch Compatibility

This table defines the maintained PyTorch mapping across the CUDA and Python lanes.

| CUDA lane | Python lanes | PyTorch lanes |
|---|---|---|
| `cu118` | `py310`, `py311`          | `torch20`, `torch21`, `torch24`, `torch25` |
| `cu118` | `py312`                   | `torch24`, `torch25` |
| `cu121` | `py310`, `py311`, `py312` | `torch24`, `torch25` |
| `cu128` | `py310`, `py311`, `py312` | `torch211` |
| `cu130` | `py310`, `py311`, `py312` | `torch211` |

### Output Image Tags

Each maintained combination produces a corresponding Layer 2 image:

| Image | CUDA | Python | PyTorch |
|---|---|---:|---:|
| `gs/torch:py310-torch20-cu118`  | 11.8 | 3.10 | 2.0.x |
| `gs/torch:py311-torch20-cu118`  | 11.8 | 3.11 | 2.0.x |
| `gs/torch:py310-torch21-cu118`  | 11.8 | 3.10 | 2.1.x |
| `gs/torch:py311-torch21-cu118`  | 11.8 | 3.11 | 2.1.x |
| `gs/torch:py310-torch24-cu118`  | 11.8 | 3.10 | 2.4.x |
| `gs/torch:py311-torch24-cu118`  | 11.8 | 3.11 | 2.4.x |
| `gs/torch:py312-torch24-cu118`  | 11.8 | 3.12 | 2.4.x |
| `gs/torch:py310-torch25-cu118`  | 11.8 | 3.10 | 2.5.x |
| `gs/torch:py311-torch25-cu118`  | 11.8 | 3.11 | 2.5.x |
| `gs/torch:py312-torch25-cu118`  | 11.8 | 3.12 | 2.5.x |
| `gs/torch:py310-torch24-cu121`  | 12.1 | 3.10 | 2.4.x |
| `gs/torch:py311-torch24-cu121`  | 12.1 | 3.11 | 2.4.x |
| `gs/torch:py312-torch24-cu121`  | 12.1 | 3.12 | 2.4.x |
| `gs/torch:py310-torch25-cu121`  | 12.1 | 3.10 | 2.5.x |
| `gs/torch:py311-torch25-cu121`  | 12.1 | 3.11 | 2.5.x |
| `gs/torch:py312-torch25-cu121`  | 12.1 | 3.12 | 2.5.x |
| `gs/torch:py310-torch211-cu128` | 12.8 | 3.10 | 2.11.x |
| `gs/torch:py311-torch211-cu128` | 12.8 | 3.11 | 2.11.x |
| `gs/torch:py312-torch211-cu128` | 12.8 | 3.12 | 2.11.x |
| `gs/torch:py310-torch211-cu130` | 13.0 | 3.10 | 2.11.x |
| `gs/torch:py311-torch211-cu130` | 13.0 | 3.11 | 2.11.x |
| `gs/torch:py312-torch211-cu130` | 13.0 | 3.12 | 2.11.x |

### Notes

- `torch20` is retained for OpenMMLab 3.0-3.2 projects that require `mmcv==2.0.x`
- `torch21` is retained mainly for older or more fragile project stacks
- `torch24` serves as a bridge between legacy and modern PyTorch versions
- `torch25` is the **main transition lane** and is the broadest compatibility choice
- `torch211` is the **preferred modern runtime** lane for current and future-oriented projects
- `cu130` should be treated as more **experimental** than the core maintained set, even when paired with `torch211`

### Version Compat Notes

| Dependency | PyTorch 2.0.x | PyTorch 2.1.x | PyTorch 2.4.x | PyTorch 2.5.x | PyTorch 2.11.x |
|------------|---------------|---------------|---------------|---------------|----------------|
| **MMCV 2.0.x**  | + | x | x | x | x |
| **MMCV 2.1.x**  | x | + | x | x | x |
| **MMCV 2.2.x+** | x | x | + | + | + |
| **Triton**      | 2.0.x | 2.1.x | 3.0.x | 3.1.x | 3.2.x+ |

MMCV 1.x has stricter requirements than MMCV 2.x:

| MMCV 1.x | PyTorch        | Python     | CUDA   | Notes |
| -------- | -------------- | ---------- | ------ | ----- |
| 1.6.x    | 1.8.x - 1.13.x | 3.6 - 3.9  | <=11.6 |       |
| 1.7.x    | 1.8.x - 2.0.x  | 3.7 - 3.10 | <=11.6 | Partial 2.0.x support |

## 6. Project Compatibility Overlays (Layer 3)

Layer 3 overlays define project-specific dependency constraints.

Typical examples include:

- NumPy `1.x` vs `2.x`
- MMCV version pinning
- Open3D compatibility
- custom CUDA extension requirements
- repo-specific build patches

These constraints should **not** be pushed down into the shared CUDA or PyTorch layers.

### Examples

| Overlay type | Example |
|---|---|
| NumPy compatibility | `numpy1`, `numpy2` |
| Legacy OpenMMLab compatibility | `mmcv16`, `mmcv20`, `mmcv21` |
| Project-specific overlay | `vanilla-gs`, `local-dygs`, `swift4d` |

---

## References

- [PyTorch release compatibility matrix](https://github.com/pytorch/pytorch/blob/main/RELEASE.md)
- [PyTorch previous versions](https://pytorch.org/get-started/previous-versions/)
- [NVIDIA CUDA container catalog](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda)
- [MMCV compatibility](https://mmcv.readthedocs.io/en/latest/get_started/installation.html)