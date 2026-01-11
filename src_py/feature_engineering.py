from __future__ import annotations

from pathlib import Path

from src_py.utils import (
    PROJECT_ROOT,
    derive_outreach_success,
    read_csv,
    safe_divide,
    write_csv,
)


def create_features(
    demographics_path: Path,
    purchase_path: Path,
    social_path: Path,
    behavioral_path: Path,
    output_path: Path,
) -> None:
    demographics = {row["customer_id"]: row for row in read_csv(demographics_path)}
    purchases = {row["customer_id"]: row for row in read_csv(purchase_path)}
    social = {row["customer_id"]: row for row in read_csv(social_path)}
    behavioral = {row["customer_id"]: row for row in read_csv(behavioral_path)}

    rows = []
    for customer_id, demo in demographics.items():
        purchase = purchases[customer_id]
        social_row = social[customer_id]
        behavioral_row = behavioral[customer_id]

        total_purchases = float(purchase["total_purchases"])
        avg_purchase_value = float(purchase["avg_purchase_value"])
        total_interactions = float(social_row["total_interactions"])
        avg_interactions_per_day = float(social_row["avg_interactions_per_day"])
        total_page_views = float(behavioral_row["total_page_views"])
        avg_time_spent = float(behavioral_row["avg_time_spent"])

        purchase_per_interaction = safe_divide(total_purchases, total_interactions, default=0)
        time_per_page_view = safe_divide(avg_time_spent, total_page_views, default=0)

        outreach_success = derive_outreach_success(total_purchases, total_interactions, avg_time_spent)

        rows.append(
            {
                "customer_id": customer_id,
                "gender": demo["gender"],
                "region": demo["region"],
                "age_group": demo["age_group"],
                "total_purchases": round(total_purchases, 2),
                "avg_purchase_value": round(avg_purchase_value, 2),
                "total_interactions": int(total_interactions),
                "avg_interactions_per_day": round(avg_interactions_per_day, 2),
                "total_page_views": int(total_page_views),
                "avg_time_spent": round(avg_time_spent, 2),
                "purchase_per_interaction": round(purchase_per_interaction, 4),
                "time_per_page_view": round(time_per_page_view, 6),
                "outreach_success": outreach_success,
            }
        )

    fieldnames = [
        "customer_id",
        "gender",
        "region",
        "age_group",
        "total_purchases",
        "avg_purchase_value",
        "total_interactions",
        "avg_interactions_per_day",
        "total_page_views",
        "avg_time_spent",
        "purchase_per_interaction",
        "time_per_page_view",
        "outreach_success",
    ]
    write_csv(output_path, rows, fieldnames)


def run() -> None:
    data_dir = PROJECT_ROOT / "data"
    create_features(
        data_dir / "preprocessed_demographics.csv",
        data_dir / "preprocessed_purchase_history.csv",
        data_dir / "preprocessed_social_media.csv",
        data_dir / "preprocessed_behavioral_data.csv",
        data_dir / "features.csv",
    )


if __name__ == "__main__":
    run()
