from nf_prefix_tree import PyPrefixTree

t = PyPrefixTree()

t.addSequence('ABCDE', 'key1')
t.addSequence('ABCXY', 'key2')
t.addSequence('ZYAPW', 'key3')

t.show()