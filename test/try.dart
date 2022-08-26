import 'dart:math';
import 'dart:typed_data';

import 'package:encrypto_flutter/bitcount/bitcount.dart';

class Try {
  late List<int> mag;
  late int signum;
  int bitLengthx = 0, firstNonzeroIntNumx = 0;
  static int LONG_MASK = 0xffffffff;
  static const double MAX_MAG_LENGTH = 2147483647 / 32 + 1;

  Try(Uint8List val) {
    if (val[0] < 0) {
      mag = makePositive(val);
      signum = -1;
    } else {
      mag = stripLeadingZeroBytes(val);
      signum = (mag.isEmpty ? 0 : 1);
    }

    if (mag.length >= MAX_MAG_LENGTH) {
      checkRange();
    }
  }

  static List<int> makePositive(Uint8List a) {
    int keep, k;
    int byteLength = a.length;

    // Find first non-sign (0xff) byte of input
    for (keep = 0; keep < byteLength && a[keep] == -1; keep++);

    /* Allocate output array.  If all non-sign bytes are 0x00, we must
         * allocate space for one extra output byte. */
    for (k = keep; k < byteLength && a[k] == 0; k++);

    int extraByte = (k == byteLength) ? 1 : 0;
    int intLength = ((byteLength - keep + extraByte) + 3) >>> 2;
    Uint8List result = Uint8List(intLength);

    /* Copy one's complement of input into output, leaving extra
         * byte (if it exists) == 0x00 */
    int b = byteLength - 1;
    for (int i = intLength - 1; i >= 0; i--) {
      result[i] = a[b--] & 0xff;
      int numBytesToTransfer = min(3, b - keep + 1);
      if (numBytesToTransfer < 0) {
        numBytesToTransfer = 0;
      }
      for (int j = 8; j <= 8 * numBytesToTransfer; j += 8) {
        result[i] |= ((a[b--] & 0xff) << j);
      }

      // Mask indicates which bits must be complemented
      int mask = -1 >>> (8 * (3 - numBytesToTransfer));
      result[i] = ~result[i] & mask;
    }

    // Add one to one's complement to generate two's complement
    for (int i = result.length - 1; i >= 0; i--) {
      result[i] = ((result[i] & LONG_MASK) + 1);
      if (result[i] != 0) {
        break;
      }
    }
    return result;
  }

  static List<int> stripLeadingZeroBytes(Uint8List a) {
    int byteLength = a.length;
    int keep;

    // Find first nonzero byte
    for (keep = 0; keep < byteLength && a[keep] == 0; keep++);

    // Allocate new array and copy relevant part of input array
    int intLength = ((byteLength - keep) + 3) >>> 2;
    List<int> result = Uint8List(intLength);
    int b = byteLength - 1;
    for (int i = intLength - 1; i >= 0; i--) {
      result[i] = a[b--] & 0xff;
      int bytesRemaining = b - keep + 1;
      int bytesToTransfer = min(3, bytesRemaining);
      for (int j = 8; j <= (bytesToTransfer << 3); j += 8) {
        result[i] |= ((a[b--] & 0xff) << j);
      }
    }
    return result;
  }

  void checkRange() {
    if (mag.length > MAX_MAG_LENGTH ||
        mag.length == MAX_MAG_LENGTH && mag[0] < 0) {
      reportOverflow();
    }
  }

  void reportOverflow() {
    throw Exception("BigInteger would overflow supported range");
  }

  Uint8List toByteArray() {
    int byteLen = (bitLength() / 8 + 1).toInt();
    Uint8List byteArray = Uint8List(byteLen);

    for (int i = byteLen - 1, bytesCopied = 4, nextInt = 0, intIndex = 0;
        i >= 0;
        i--) {
      if (bytesCopied == 4) {
        nextInt = getInt(intIndex++);
        bytesCopied = 1;
      } else {
        nextInt >>>= 8;
        bytesCopied++;
      }
      byteArray[i] = nextInt;
    }
    return byteArray;
  }

  int bitLength() {
    int n = bitLengthx - 1;
    if (n == -1) {
      // bitLength not initialized yet
      List<int> m = mag;
      int len = m.length;
      if (len == 0) {
        n = 0; // offset by one to initialize
      } else {
        // Calculate the bit length of the magnitude
        int magBitLength = ((len - 1) << 5) + bitLengthForInt(mag[0]);
        if (signum < 0) {
          // Check if magnitude is a power of two
          bool pow2 = (mag[0].bitCount() == 1);
          for (int i = 1; i < len && pow2; i++) {
            pow2 = (mag[i] == 0);
          }

          n = (pow2 ? magBitLength - 1 : magBitLength);
        } else {
          n = magBitLength;
        }
      }
      bitLengthx = n + 1;
    }
    return n;
  }

  static int bitLengthForInt(int n) {
    return 32 - numberOfLeadingZeros(n);
  }

  static int numberOfLeadingZeros(int i) {
    // HD, Figure 5-6
    if (i == 0) {
      return 32;
    }
    int n = 1;
    if (i >>> 16 == 0) {
      n += 16;
      i <<= 16;
    }
    if (i >>> 24 == 0) {
      n += 8;
      i <<= 8;
    }
    if (i >>> 28 == 0) {
      n += 4;
      i <<= 4;
    }
    if (i >>> 30 == 0) {
      n += 2;
      i <<= 2;
    }
    n -= i >>> 31;
    return n;
  }

  int getInt(int n) {
    if (n < 0) {
      return 0;
    }
    if (n >= mag.length) {
      return signInt();
    }

    int magInt = mag[mag.length - n - 1];

    return (signum >= 0
        ? magInt
        : (n <= firstNonzeroIntNum() ? -magInt : ~magInt));
  }

  int signInt() {
    return signum < 0 ? -1 : 0;
  }

  int firstNonzeroIntNum() {
    int fn = firstNonzeroIntNumx - 2;
    if (fn == -2) {
      // firstNonzeroIntNum not initialized yet
      fn = 0;

      // Search for the first nonzero int
      int i;
      int mlen = mag.length;
      for (i = mlen - 1; i >= 0 && mag[i] == 0; i--);
      fn = mlen - i - 1;
      firstNonzeroIntNumx = fn + 2; // offset by two to initialize
    }
    return fn;
  }
}
