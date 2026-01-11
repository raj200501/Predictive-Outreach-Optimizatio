import unittest
from pathlib import Path

from src_py import data_preprocessing, feature_engineering, model_training
from src_py.utils import PROJECT_ROOT, read_csv


class PipelineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        data_preprocessing.run()
        feature_engineering.run()
        model_training.run()

    def test_preprocessing_outputs(self):
        data_dir = PROJECT_ROOT / "data"
        demographics = read_csv(data_dir / "preprocessed_demographics.csv")
        self.assertGreater(len(demographics), 0)
        self.assertIn("age_group", demographics[0])

        purchase = read_csv(data_dir / "preprocessed_purchase_history.csv")
        self.assertIn("total_purchases", purchase[0])

    def test_feature_engineering_outputs(self):
        features = read_csv(PROJECT_ROOT / "data" / "features.csv")
        self.assertGreater(len(features), 0)
        self.assertIn("purchase_per_interaction", features[0])
        self.assertIn("outreach_success", features[0])

    def test_model_artifact(self):
        model_path = PROJECT_ROOT / "models" / "outreach_model.json"
        self.assertTrue(model_path.exists())


if __name__ == "__main__":
    unittest.main()
