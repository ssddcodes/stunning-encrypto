import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypto_flutter/encrypto_flutter.dart';

void main() {
  // var bitLen = 1024;
  // // var x = Encrypto(Encrypto.RSA, bitLength: 1024);
  // BigInt p = randomPrimeBigInt(bitLen), q = randomPrimeBigInt(bitLen);
  // BigInt n = p * q, pm1 = p - BigInt.one, qm1 = q - BigInt.one;
  // BigInt on = pm1 * qm1, e = randomPrimeBigInt(bitLen);
  // BigInt d = e.modInverse(on);
  //
  // print(((e * d) % on).toInt() == 1); //must be true
  //
  // List<int> bytes = const Utf8Encoder().convert('abc');
  // var xyz = const Base64Encoder().convert(
  //     _writeBigInt(((_readBytes(Uint8List.fromList(bytes)) * e) % on)));
  //
  // print(xyz); //prints encrypted base64 string
  //
  // var zyxunit8 =
  //     _writeBigInt((_readBytes(const Base64Decoder().convert(xyz)) * d) % on);
  // var zyx = String.fromCharCodes(zyxunit8);
  //
  // print(zyx); // prints decrypted message

  Encrypto encrypto = Encrypto(Encrypto.RSA);
  var b64enc = encrypto.encrypt('alo', publicKey: encrypto.getPublicKey());
  var txt = encrypto.decrypt(b64enc);

  print(txt);

  // List<int> bytes = const Utf8Encoder().convert('cata');
  // print(Idk(Uint8List.fromList(bytes)).toByteArray());
  // print(_readBytes(Uint8List.fromList(utf8.encode('ab'))));
  // print(_writeBigInt(_readBytes(Uint8List.fromList(utf8.encode('ab')))));

  // Uint8List y = _writeBigInt(_convertBytesToBigInt(_writeBigInt(
  //         _convertBytesToBigInt(
  //                 Uint8List.fromList(const Utf8Encoder().convert('ab'))) *
  //             BigInt.two)) ~/
  //     BigInt.two);
  // print(y);

  // BigInt d = BigInt.parse(
  //     '2966664163187118470779092082717517720920427538600685193561871027918312935945740238096565245763321389576329665542363585631617483014641372259000364961653275');
  // BigInt on = BigInt.parse(
  //     '9247866515353349060658907844721271013552160071917706902241653660630456364854403564390774987763930906793322399015891887448122217293551012623998052045891392');
  // var x = String.fromCharCodes(_writeBigInt((_convertBytesToBigInt(
  //             const Base64Decoder().convert(
  //                 'NwCfv1/c8r//au2Xie6R1RiZ1uUY6/MhMLshCb5q6S98xg==')) *
  //         d) %
  //     on));
  // print(x);
}

BigInt _convertBytesToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;

  for (final byte in bytes) {
// reading in big-endian, so we essentially concat the new byte to the end
    result = (result << 8) | BigInt.from(byte & 0xff);
  }
  return result;
}

Uint8List _writeBigInt(BigInt number) {
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
