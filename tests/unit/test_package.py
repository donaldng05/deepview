"""Basic sanity test for deepview package metadata."""

import deepview


def test_package_version():
    assert deepview.__version__ == "0.2.0.dev0"
