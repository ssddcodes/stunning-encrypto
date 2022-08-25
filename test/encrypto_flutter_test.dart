import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypto_flutter/primegen.dart';

void main() {
  var bitLen = 1024;
  // var x = Encrypto(Encrypto.RSA, bitLength: 1024);
  BigInt p = randomPrimeBigInt(bitLen), q = randomPrimeBigInt(bitLen);
  BigInt n = p * q, pm1 = p - BigInt.one, qm1 = q - BigInt.one;
  BigInt on = pm1 * qm1, e = randomPrimeBigInt(bitLen);
  BigInt d = e.modInverse(on);

  print(((e * d) % on).toInt() == 1); //must be true

  List<int> bytes = const Utf8Encoder().convert('abc');
  var xyz = const Base64Encoder().convert(
      _writeBigInt(((_readBytes(Uint8List.fromList(bytes)) * e) % on)));

  print(xyz); //prints encrypted base64 string

  var zyxunit8 =
      _writeBigInt((_readBytes(const Base64Decoder().convert(xyz)) * d) % on);
  var zyx = String.fromCharCodes(zyxunit8);

  print(zyx); // prints decrypted message

  // Encrypto encrypto = Encrypto(Encrypto.RSA);
  // var b64enc = encrypto.encrypt('alo', publicKey: encrypto.getPublicKey());
  // var txt = encrypto.decrypt(b64enc);
  // print(txt);
}

BigInt _readBytes(Uint8List bytes) {
  BigInt read(int start, int end) {
    if (end - start <= 4) {
      int result = 0;
      for (int i = end - 1; i >= start; i--) {
        result = result * 256 + bytes[i];
      }
      return BigInt.from(result);
    }
    int mid = start + ((end - start) >> 1);
    var result =
        read(start, mid) + read(mid, end) * (BigInt.one << ((mid - start) * 8));
    return result;
  }

  return read(0, bytes.length);
}

Uint8List _writeBigInt(BigInt number) {
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
