# DeepView: Volumetric to Surface Mesh Estimation for Industrial NDT

[![CI](https://github.com/donaldng05/deepview/actions/workflows/ci.yml/badge.svg)](https://github.com/donaldng05/deepview/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python: 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

DeepView is a computer vision research study focused on estimating 3D surface geometry from volumetric ultrasound data in Non-Destructive Testing (NDT) of industrial piping.

The project originated as an entry in the UBC Data Science Club Hackathon, centered on the **CVPR 2023 Deep Learning in Ultrasound Image Analysis Workshop Challenge** (provided by DarkVision Technologies). It has been restructured as a rigorous, reproducible benchmark investigating why direct mesh coordinate regression fails on volumetric data and how segmentation-based approaches (such as SMRVIS) restore geometric fidelity.

---

## 🎯 Objectives & Research Questions

1. **Why Direct Coordinate Regression Fails:** Analyze the representation bottlenecks of compressing 3D volumes into flat feature vectors (e.g., via global pooling) and regressing unordered vertex arrays with non-geometric loss functions (MSE).
2. **Re-implementation of SMRVIS:** Provide an independent, reproducible re-implementation of the slice-based 2.5D segmentation approach proposed by Tang ([arXiv:2306.04668](https://arxiv.org/abs/2306.04668)), testing the impact of mask dilation, slice selection, and loss formulations (BCE/Focal vs. Dice).
3. **3D vs. 2.5D Volumetric Modeling:** Compare 2.5D slice-triplet models against full 3D convolutional segmenters under identical evaluation constraints.
4. **Controlled Synthetic Benchmark (`NDT-Pipe3D`):** Provide a reproducible, open-source parametric pipe generator paired with acoustic artifact modeling (speckle noise, attenuation, beam blur) with exact ground-truth surfaces.

---

## 📐 Evaluation Protocol

All models are evaluated under a unified, unit-tested protocol in physical millimeter space:

- **Protocol Chamfer Distance ($\text{CD}^2$):** Kept in squared distance form following the CVPR challenge protocol (10,000 points sampled per cloud) for direct comparability with published literature.
- **Physical Chamfer Distance ($\text{CD}$):** Unsquared L1 and L2 point set distances in millimeters.
- **Direct Hausdorff & HD95:** Maximum and 95th-percentile surface error in millimeters.
- **Surface $F_1$-Score at threshold $\tau$ ($F_1(\tau)$):** Harmonic mean of precision and recall at calibrated physical tolerances (e.g., $\tau \in \{1\text{mm}, 2\text{mm}, 5\text{mm}\}$).

*Note: All distance metrics operate on area-uniform point cloud samples in physical coordinates without per-sample scale normalization.*

---

## 📁 Repository Structure

```
deepview/
├── .github/workflows/   # CI test & lint pipelines, CodeQL security analysis
├── configs/             # Experiment, model, and dataset configurations (YAML)
│   ├── dataset/
│   ├── experiment/
│   └── model/
├── docs/                # Architecture, data policies, decisions, and plans
├── results/             # Run records, evaluated point clouds, and metrics
├── scripts/             # CLI entrypoints for data generation, training, and evaluation
├── src/deepview/        # Core deepview Python package
│   ├── data/            # Synthetic generator, IO loaders, and preprocessing
│   ├── evaluation/      # Evaluation runner, threshold selection, and reporting
│   ├── geometry/        # Pure metric functions (Chamfer, HD95, F1), affine transforms
│   ├── models/          # 2.5D slice segmenters, 3D U-Nets, and baseline regressors
│   └── training/        # PyTorch training loops, loss functions, and schedulers
└── tests/               # Comprehensive pytest test suite
    ├── conftest.py      # Deterministic fixtures
    ├── known_answer/    # Analytical ground-truth tests for metrics
    ├── smoke/           # Fast CPU end-to-end integration tests
    └── unit/            # Isolated component tests
```

---

## ⚡ Quickstart

This project uses [`uv`](https://docs.astral.sh/uv/) for deterministic, high-speed dependency management and virtual environments.

### 1. Clone & Setup Environment

```bash
git clone https://github.com/donaldng05/deepview.git
cd deepview

# Create isolated .venv and install all dependencies (including dev and viz tools)
uv sync --all-extras
```

### 2. Run Quality Checks & Tests

```bash
# Run test suite
uv run pytest

# Run linting and formatting checks
uv run ruff check src tests scripts
uv run ruff format --check src tests scripts

# Run static type checking
uv run mypy src
```

Convenience targets are also available via the `Makefile` (`make sync`, `make test`, `make lint`, `make format`).

---

## 🔒 Data Policy & Hygiene

- **No Restricted Data:** In accordance with the original competition guidelines, proprietary challenge ultrasound volumes (`.raw`) and reference meshes (`.ply`) are **not** distributed in this repository.
- **Reproducible Science:** All experiments, benchmarks, and baseline comparisons are conducted using the fully open-source, procedural `NDT-Pipe3D` generator.
- **Run Record Traceability:** All published metric tables and plots trace directly to immutable, versioned run records stored in `results/`.

---

## 📚 References & Acknowledgments

- **SMRVIS Reference:** Tang, L. Y. W. (2023). *SMRVIS: Point cloud extraction from 3-D ultrasound for non-destructive testing.* [arXiv:2306.04668](https://arxiv.org/abs/2306.04668).
- **Challenge Host:** DarkVision Technologies & CVPR 2023 Workshop on Deep Learning in Ultrasound Image Analysis.
- **Original Hackathon:** UBC Data Science Club Hackathon (Team BOOST).
