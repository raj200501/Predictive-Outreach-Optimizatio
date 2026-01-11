import unittest

from src_py import utils


class UtilsTests(unittest.TestCase):
    def test_safe_divide(self):
        self.assertEqual(utils.safe_divide(10, 2), 5)
        self.assertEqual(utils.safe_divide(10, 0, default=0), 0)

    def test_normalize_region(self):
        self.assertEqual(utils.normalize_region("north"), "North")
        self.assertEqual(utils.normalize_region("  SOUTH "), "South")
        self.assertEqual(utils.normalize_region("unknown"), "Unknown")

    def test_derive_outreach_success(self):
        self.assertEqual(utils.derive_outreach_success(2000, 60, 10), "yes")
        self.assertEqual(utils.derive_outreach_success(100, 2, 1), "no")


if __name__ == "__main__":
    unittest.main()
