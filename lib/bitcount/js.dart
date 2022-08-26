const _30Bits = (1 << 30);

// Described in Hacker's Delight (Figure 5-2).
int _bitCount32(int n) {
  n = n - ((n >> 1) & 0x55555555);
  n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
  n = (n + (n >> 4)) & 0x0f0f0f0f;
  n = n + (n >> 8);
  n = n + (n >> 16);
  return n & 0x3f;
}

int bitCount(int n) {
  var lo30Bits = n & (_30Bits - 1);
  var hi22Bits = (n - lo30Bits) ~/ _30Bits;
  return _bitCount32(lo30Bits) + _bitCount32(hi22Bits);
}
