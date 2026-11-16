import unittest
import nf_prefix_tree

class test_nf_prefix_tree(unittest.TestCase):

    def setUp(self):
        self.t = nf_prefix_tree.PyPrefixTree()

    def test_addSequence(self):
        try:
            self.t.addSequence("ABCD", "Key1")
            self.t.addSequence("ABXY", "Key2")
        except:
            self.assertTrue(False, 'Should not throw error when adding prefixes to tree')

    def test_hasPrefix(self):
        self.t.addSequence("ABCD", "Key1")
        self.t.addSequence("ABXY", "Key2")

        self.assertTrue(self.t.hasPrefix("AB"), "Prefix AB should exist")
        self.assertTrue(self.t.hasPrefix("ABCD"), "Prefix ABCD should exist")
        self.assertTrue(self.t.hasPrefix("ABXY"), "Prefix ABXY should exist")

        self.assertFalse(self.t.hasPrefix("XY"), "Prefix not added to tree should return false")

    def test_getKeysWithPrefix(self):
        self.t.addSequence("ABCD", "Key1")
        self.t.addSequence("ABXY", "Key2")

        self.assertIn("Key1", self.t.getKeysWithPrefix("ABCD"), "Key corresponding to added prefix should be returned on query")
        self.assertIn("Key2", self.t.getKeysWithPrefix("ABXY"), "Key corresponding to added prefix should be returned on query")
        self.assertIn("Key1", self.t.getKeysWithPrefix("AB"), "Key corresponding to added prefix should be returned on query")
        self.assertIn("Key2", self.t.getKeysWithPrefix("AB"), "Key corresponding to added prefix should be returned on query")

        self.assertNotIn("Key1", self.t.getKeysWithPrefix("ABXY"), "Key not corresponding to added prefix should not be returned on query")
        self.assertNotIn("Key2", self.t.getKeysWithPrefix("ABCD"), "Key not corresponding to added prefix should not be returned on query")