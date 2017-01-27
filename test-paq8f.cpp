#include "paq8f.h"
#include <stdio.h>

int main(int argc, char** argv)
{
  test_compress();
  test_compress();
  test_compress();
  test_compress();
  char *s = "hayvan";
  float len = compressed_size_bitstring(s, 20);
  //cli(argc, argv);
}
