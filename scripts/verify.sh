#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PYTHONPATH="$ROOT_DIR"

"$ROOT_DIR/scripts/bootstrap.sh"

python "$ROOT_DIR/src_py/data_preprocessing.py"
python "$ROOT_DIR/src_py/feature_engineering.py"
python "$ROOT_DIR/src_py/model_training.py"
python "$ROOT_DIR/src_py/engagement_scoring.py"
python "$ROOT_DIR/src_py/personalized_outreach_plan.py"
python "$ROOT_DIR/src_py/outreach_prediction.py"
python "$ROOT_DIR/src_py/evaluation.py"

python -m unittest discover -s tests -p "test_*.py"
