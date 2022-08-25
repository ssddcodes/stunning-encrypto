import 'dart:convert';
import 'dart:typed_data';

class ZotPublicKey {
  BigInt e, // public key exponent
      on; // modulus (O(n))

  ZotPublicKey(this.e, this.on);

  /// returns base64 public key which can be sent to other user for encryption
  String sterilizePublicKey() {
    Base64Encoder encoder = const Base64Encoder();
    Map<String, int> x = {};
    x['pe'] = e.toInt();
    x['on'] = on.toInt();
    return encoder.convert(const Utf8Encoder().convert(jsonEncode(x)));
  }

  /// returns encrypted message
  String encrypt(String val) {
    List<int> bytes = const Utf8Encoder().convert(val);
    return const Base64Encoder().convert(ZotPublicKey.writeBigInt(
        ((ZotPublicKey.readBytes(Uint8List.fromList(bytes)) * e) % on)));
  }

  /// returns info about public key: the information contains:
  /// 1. algo, 2. modulus, 3. public exponent
  @override
  String toString() {
    return "Algo: RSA\n modulus: ${on.toString()}\npublic exponent: ${e.toString()}";
  }

  /// internal method to convert Unit8List to BigInt
  static BigInt readBytes(Uint8List bytes) {
    BigInt read(int start, int end) {
      if (end - start <= 4) {
        int result = 0;
        for (int i = end - 1; i >= start; i--) {
          result = result * 256 + bytes[i];
        }
        return BigInt.from(result);
      }
      int mid = start + ((end - start) >> 1);
      var result = read(start, mid) +
          read(mid, end) * (BigInt.one << ((mid - start) * 8));
      return result;
    }

    return read(0, bytes.length);
  }

  /// internal method to convert BigInt to Unit8List
  static Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }
}
