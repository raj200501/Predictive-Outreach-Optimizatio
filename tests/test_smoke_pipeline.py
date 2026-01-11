import unittest

from src_py import (
    data_preprocessing,
    engagement_scoring,
    feature_engineering,
    model_training,
    outreach_prediction,
    personalized_outreach_plan,
)
from src_py.utils import PROJECT_ROOT, read_csv


class SmokePipelineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        data_preprocessing.run()
        feature_engineering.run()
        model_training.run()
        engagement_scoring.run()
        personalized_outreach_plan.run()
        outreach_prediction.run()

    def test_outreach_plan(self):
        outreach_plan = read_csv(PROJECT_ROOT / "data" / "outreach_plan.csv")
        self.assertGreater(len(outreach_plan), 0)
        self.assertIn("outreach_plan", outreach_plan[0])

    def test_predictions(self):
        predictions = read_csv(PROJECT_ROOT / "data" / "predictions.csv")
        self.assertGreater(len(predictions), 0)
        self.assertIn("prediction", predictions[0])


if __name__ == "__main__":
    unittest.main()
