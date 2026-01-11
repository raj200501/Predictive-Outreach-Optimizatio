from __future__ import annotations

from pathlib import Path

from src_py.utils import PROJECT_ROOT, read_csv, safe_divide, write_csv


def score_engagement(features_path: Path, output_path: Path) -> None:
    rows = read_csv(features_path)
    scored = []
    for row in rows:
        total_interactions = float(row["total_interactions"])
        total_page_views = float(row["total_page_views"])
        total_purchases = float(row["total_purchases"])
        avg_purchase_value = float(row["avg_purchase_value"])

        engagement_score = total_interactions + total_page_views + safe_divide(
            total_purchases, avg_purchase_value, default=0
        )

        updated = dict(row)
        updated["engagement_score"] = round(engagement_score, 2)
        scored.append(updated)

    fieldnames = list(scored[0].keys()) if scored else []
    write_csv(output_path, scored, fieldnames)


def run() -> None:
    data_dir = PROJECT_ROOT / "data"
    score_engagement(data_dir / "features.csv", data_dir / "engagement_scores.csv")


if __name__ == "__main__":
    run()
