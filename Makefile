.PHONY: help install dev sync lock format lint type-check test test-known test-smoke clean

help:
	@echo "Available commands:"
	@echo "  sync         Sync virtual environment via uv (recommended)"
	@echo "  lock         Update uv.lock"
	@echo "  install      Install package in editable mode via pip"
	@echo "  dev          Install package with dev dependencies via pip"
	@echo "  format       Auto-format code with ruff"
	@echo "  lint         Run ruff checks"
	@echo "  type-check   Run mypy static type analysis"
	@echo "  test         Run all pytest tests"
	@echo "  test-known   Run analytical known-answer tests"
	@echo "  test-smoke   Run smoke tests"
	@echo "  clean        Remove build artifacts and caches"

sync:
	uv sync --all-extras

lock:
	uv lock

install:
	pip install -e .

dev:
	pip install -e ".[dev,viz]"

format:
	uv run ruff format src tests scripts
	uv run ruff check --fix src tests scripts

lint:
	uv run ruff format --check src tests scripts
	uv run ruff check src tests scripts

type-check:
	uv run mypy src

test:
	uv run pytest

test-known:
	uv run pytest -m known_answer

test-smoke:
	uv run pytest -m smoke

clean:
	python -c "import shutil, pathlib; [shutil.rmtree(p, ignore_errors=True) for p in pathlib.Path('.').rglob('__pycache__')]"
	python -c "import shutil, pathlib; [shutil.rmtree(p, ignore_errors=True) for p in pathlib.Path('.').rglob('*.egg-info')]"
	python -c "import shutil, pathlib; [shutil.rmtree(p, ignore_errors=True) for p in [pathlib.Path('.pytest_cache'), pathlib.Path('.ruff_cache'), pathlib.Path('.mypy_cache'), pathlib.Path('build'), pathlib.Path('dist')]]"
