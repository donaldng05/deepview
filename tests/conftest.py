"""Shared test fixtures and configuration."""

import numpy as np
import pytest


@pytest.fixture
def rng():
    """Deterministic random generator for reproducible tests."""
    return np.random.default_rng(seed=42)
