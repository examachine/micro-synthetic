#ifndef PAQ8F_H
#define PAQ8F_H

extern "C" {
  void init(int level=6);
  float compressed_size_bitstring(char *bitstring, int length);
  int cli(int argc, char** argv);
  void test_compress();
};

#endif
