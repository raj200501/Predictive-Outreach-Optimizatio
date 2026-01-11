from __future__ import annotations

from pathlib import Path

from src_py.utils import PROJECT_ROOT, ModelSpec, apply_model, read_csv, read_json


def evaluate(model_path: Path, test_data_path: Path) -> dict[str, int]:
    model = ModelSpec.from_dict(read_json(model_path))
    rows = read_csv(test_data_path)
    confusion = {"true_positive": 0, "true_negative": 0, "false_positive": 0, "false_negative": 0}

    for row in rows:
        prediction = apply_model(model, row)
        actual = row["outreach_success"]
        if prediction == "yes" and actual == "yes":
            confusion["true_positive"] += 1
        elif prediction == "no" and actual == "no":
            confusion["true_negative"] += 1
        elif prediction == "yes" and actual == "no":
            confusion["false_positive"] += 1
        else:
            confusion["false_negative"] += 1
    return confusion


def run() -> None:
    confusion = evaluate(PROJECT_ROOT / "models" / "outreach_model.json", PROJECT_ROOT / "data" / "test_data.csv")
    print("Confusion matrix:")
    for key, value in confusion.items():
        print(f"{key}: {value}")


if __name__ == "__main__":
    run()
