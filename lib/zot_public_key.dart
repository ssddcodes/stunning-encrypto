import 'dart:convert';
import 'dart:typed_data';

class ZotPublicKey {
  BigInt e, // public key exponent
      on; // modulus (O(n))

  ZotPublicKey(this.e, this.on);

  /// returns base64 public key which can be sent to other user for encryption
  String sterilizePublicKey() {
    Base64Encoder encoder = const Base64Encoder();
    Map<String, String> x = {};
    x['pe'] = e.toString();
    x['on'] = on.toString();
    return encoder.convert(const Utf8Encoder().convert(jsonEncode(x)));
  }

  /// returns encrypted message
  String encrypt(String val) {
    List<int> bytes = const Utf8Encoder().convert(val);
    return const Base64Encoder().convert(const Utf8Encoder().convert(((readBytes(Uint8List.fromList(bytes)) * e) % on).toString()));
  }

  /// returns info about public key: the information contains:
  /// 1. algo, 2. modulus, 3. public exponent
  @override
  String toString() {
    return "Algo: RSA\n modulus: ${on.toString()}\npublic exponent: ${e.toString()}";
  }

  /// internal method to convert Unit8List to BigInt
  static BigInt readBytes(Uint8List bytes) {
    BigInt result = BigInt.zero;

    for (final byte in bytes) {
      // reading in big-endian, so we essentially concat the new byte to the end
      result = (result << 8) | BigInt.from(byte & 0xff);
    }
    return result;
  }

  /// internal method to convert BigInt to Unit8List
  static Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = BigInt.from(256);
    var result = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[bytes - 1 - i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }
}
