from __future__ import annotations

from pathlib import Path

from src_py.utils import PROJECT_ROOT, ModelSpec, apply_model, read_csv, read_json, write_csv


def predict(model_path: Path, new_data_path: Path, output_path: Path) -> None:
    model = ModelSpec.from_dict(read_json(model_path))
    rows = read_csv(new_data_path)
    predictions = []
    for row in rows:
        prediction = apply_model(model, row)
        predictions.append({"customer_id": row["customer_id"], "prediction": prediction})
    write_csv(output_path, predictions, ["customer_id", "prediction"])


def run() -> None:
    data_dir = PROJECT_ROOT / "data"
    predict(
        PROJECT_ROOT / "models" / "outreach_model.json",
        data_dir / "new_data.csv",
        data_dir / "predictions.csv",
    )


if __name__ == "__main__":
    run()
