from __future__ import annotations

from pathlib import Path

from src_py.utils import (
    PROJECT_ROOT,
    age_group,
    normalize_region,
    read_csv,
    summarize_group,
    group_numeric,
    write_csv,
)


def preprocess_demographics(input_path: Path, output_path: Path) -> None:
    demographics = read_csv(input_path)
    processed = []
    for row in demographics:
        processed.append(
            {
                "customer_id": row["customer_id"],
                "gender": row["gender"],
                "region": normalize_region(row["region"]),
                "age_group": age_group(int(row["age"])),
            }
        )
    write_csv(output_path, processed, ["customer_id", "gender", "region", "age_group"])


def preprocess_purchase_history(input_path: Path, output_path: Path) -> None:
    grouped = group_numeric(read_csv(input_path), "customer_id", "purchase_amount")
    summary = summarize_group(grouped)
    processed = [
        {
            "customer_id": customer_id,
            "total_purchases": round(values["total"], 2),
            "avg_purchase_value": round(values["average"], 2),
        }
        for customer_id, values in summary.items()
    ]
    write_csv(output_path, processed, ["customer_id", "total_purchases", "avg_purchase_value"])


def preprocess_social_media(input_path: Path, output_path: Path) -> None:
    grouped = group_numeric(read_csv(input_path), "customer_id", "interactions")
    summary = summarize_group(grouped)
    processed = [
        {
            "customer_id": customer_id,
            "total_interactions": int(values["total"]),
            "avg_interactions_per_day": round(values["average"], 2),
        }
        for customer_id, values in summary.items()
    ]
    write_csv(output_path, processed, ["customer_id", "total_interactions", "avg_interactions_per_day"])


def preprocess_behavioral(input_path: Path, output_path: Path) -> None:
    rows = read_csv(input_path)
    grouped: dict[str, list[tuple[int, float]]] = {}
    for row in rows:
        grouped.setdefault(row["customer_id"], []).append((int(row["page_views"]), float(row["time_spent"])))

    processed = []
    for customer_id, values in grouped.items():
        total_page_views = sum(item[0] for item in values)
        avg_time_spent = sum(item[1] for item in values) / len(values)
        processed.append(
            {
                "customer_id": customer_id,
                "total_page_views": total_page_views,
                "avg_time_spent": round(avg_time_spent, 2),
            }
        )
    write_csv(output_path, processed, ["customer_id", "total_page_views", "avg_time_spent"])


def run() -> None:
    data_dir = PROJECT_ROOT / "data"
    preprocess_demographics(
        data_dir / "customer_demographics.csv",
        data_dir / "preprocessed_demographics.csv",
    )
    preprocess_purchase_history(
        data_dir / "purchase_history.csv",
        data_dir / "preprocessed_purchase_history.csv",
    )
    preprocess_social_media(
        data_dir / "social_media_interactions.csv",
        data_dir / "preprocessed_social_media.csv",
    )
    preprocess_behavioral(
        data_dir / "behavioral_data.csv",
        data_dir / "preprocessed_behavioral_data.csv",
    )


if __name__ == "__main__":
    run()
