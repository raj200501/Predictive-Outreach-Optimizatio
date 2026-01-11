from __future__ import annotations

from pathlib import Path

from src_py.utils import PROJECT_ROOT, build_threshold_model, read_csv, write_json


NUMERIC_FEATURES = [
    "total_purchases",
    "avg_purchase_value",
    "total_interactions",
    "avg_interactions_per_day",
    "total_page_views",
    "avg_time_spent",
    "purchase_per_interaction",
    "time_per_page_view",
]


def train_model(features_path: Path, output_path: Path) -> None:
    rows = read_csv(features_path)
    model = build_threshold_model(rows, NUMERIC_FEATURES)
    write_json(output_path, model.to_dict())


def run() -> None:
    models_dir = PROJECT_ROOT / "models"
    models_dir.mkdir(exist_ok=True)
    train_model(PROJECT_ROOT / "data" / "features.csv", models_dir / "outreach_model.json")


if __name__ == "__main__":
    run()
