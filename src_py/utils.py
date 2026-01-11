from __future__ import annotations

import csv
import json
from collections import defaultdict
from dataclasses import dataclass
from pathlib import Path
from statistics import mean, median
from typing import Dict, Iterable, List, Sequence


PROJECT_ROOT = Path(__file__).resolve().parents[1]


def ensure_dir(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def read_csv(path: Path) -> List[Dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        return list(reader)


def write_csv(path: Path, rows: Sequence[Dict[str, object]], fieldnames: Sequence[str]) -> None:
    ensure_dir(path.parent)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def safe_divide(numerator: float, denominator: float, default: float = 0.0) -> float:
    if denominator in (0, None):
        return default
    return numerator / denominator


def normalize_region(region: str) -> str:
    value = region.strip().lower()
    if value not in {"north", "south", "east", "west"}:
        value = "unknown"
    return value.title()


def age_group(age: int) -> str:
    if age < 18:
        return "Under 18"
    if age < 35:
        return "18-34"
    if age < 50:
        return "35-49"
    if age < 65:
        return "50-64"
    return "65+"


def derive_outreach_success(total_purchases: float, total_interactions: float, avg_time_spent: float) -> str:
    score = (total_purchases / 500) + (total_interactions / 20) + (avg_time_spent / 5)
    return "yes" if score >= 3 else "no"


def group_numeric(rows: Iterable[Dict[str, str]], key_field: str, value_field: str) -> Dict[str, List[float]]:
    grouped: Dict[str, List[float]] = defaultdict(list)
    for row in rows:
        grouped[row[key_field]].append(float(row[value_field]))
    return grouped


def summarize_group(grouped: Dict[str, List[float]]) -> Dict[str, Dict[str, float]]:
    summary: Dict[str, Dict[str, float]] = {}
    for key, values in grouped.items():
        summary[key] = {
            "total": sum(values),
            "average": mean(values),
        }
    return summary


def read_json(path: Path) -> Dict[str, object]:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def write_json(path: Path, payload: Dict[str, object]) -> None:
    ensure_dir(path.parent)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2, sort_keys=True)


@dataclass
class ModelSpec:
    numeric_features: List[str]
    thresholds: Dict[str, float]
    decision_threshold: float

    def to_dict(self) -> Dict[str, object]:
        return {
            "numeric_features": self.numeric_features,
            "thresholds": self.thresholds,
            "decision_threshold": self.decision_threshold,
        }

    @classmethod
    def from_dict(cls, payload: Dict[str, object]) -> "ModelSpec":
        return cls(
            numeric_features=list(payload["numeric_features"]),
            thresholds={key: float(value) for key, value in payload["thresholds"].items()},
            decision_threshold=float(payload["decision_threshold"]),
        )


def build_threshold_model(rows: Sequence[Dict[str, str]], numeric_features: Sequence[str]) -> ModelSpec:
    positive_rows = [row for row in rows if row.get("outreach_success") == "yes"]
    if not positive_rows:
        raise ValueError("No positive training rows available to derive thresholds.")

    thresholds: Dict[str, float] = {}
    for feature in numeric_features:
        values = [float(row[feature]) for row in positive_rows]
        thresholds[feature] = median(values)

    return ModelSpec(
        numeric_features=list(numeric_features),
        thresholds=thresholds,
        decision_threshold=0.5,
    )


def apply_model(model: ModelSpec, row: Dict[str, str]) -> str:
    hits = 0
    for feature in model.numeric_features:
        if float(row[feature]) >= model.thresholds[feature]:
            hits += 1
    score = hits / len(model.numeric_features)
    return "yes" if score >= model.decision_threshold else "no"
