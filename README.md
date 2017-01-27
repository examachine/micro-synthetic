# Micro-Synthetic

This is an OCaml implementation of the Micro-Synthetic algorithm, which is a universal data mining method that uses the Normalized Compression Distance to generalize frequent pattern discovery.

Please see the draft paper at https://arxiv.org/abs/1202.2167 to see what this is all about. 

A strange objection to the paper from a reviewer was that the algorithm would be too inefficient. This algorithm is not meant to be efficient, it only serves to validate the universal pattern recognition theory developed in the above paper. Furthermore, frequent pattern discovery algorithms are not very efficient, they are exhaustive pattern search algorithms with an important optimization called the Downward Lemma, which is perfectly realized in the universal frequent pattern discovery algorithm presented.

Eray Ozkural


