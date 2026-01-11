from __future__ import annotations

from pathlib import Path

from src_py.utils import PROJECT_ROOT, read_csv, write_csv


def generate_plan(features_path: Path, engagement_path: Path, output_path: Path) -> None:
    features = {row["customer_id"]: row for row in read_csv(features_path)}
    engagement_rows = read_csv(engagement_path)
    plans = []

    for row in engagement_rows:
        customer_id = row["customer_id"]
        engagement_score = float(row["engagement_score"])
        plan = "Low Priority"
        if engagement_score > 8:
            plan = "High Priority"
        elif engagement_score > 5:
            plan = "Medium Priority"

        merged = dict(features[customer_id])
        merged["engagement_score"] = row["engagement_score"]
        merged["outreach_plan"] = plan
        plans.append(merged)

    fieldnames = list(plans[0].keys()) if plans else []
    write_csv(output_path, plans, fieldnames)


def run() -> None:
    data_dir = PROJECT_ROOT / "data"
    generate_plan(data_dir / "features.csv", data_dir / "engagement_scores.csv", data_dir / "outreach_plan.csv")


if __name__ == "__main__":
    run()
