import 'dart:convert';

import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:encrypto_flutter/keypair.dart';
import 'package:encrypto_flutter/primegen.dart';
import 'package:encrypto_flutter/zot_public_key.dart';

class ZotPrivateKey {
  late BigInt _on, // modulus (O(n))
      _d; // private exponent
  ZotPrivateKey(int bitLen, ZotKeyPair zotKeyPair, Encrypto encrypto) {
    BigInt p = randomPrimeBigInt(bitLen), q = randomPrimeBigInt(bitLen);
    BigInt n = p * q, pm1 = p - BigInt.one, qm1 = q - BigInt.one;
    _on = pm1 * qm1;
    BigInt e = randomPrimeBigInt(bitLen);
    _d = e.modInverse(_on);
    _assetEq(((e * _d) % _on));
    zotKeyPair.publicKey = ZotPublicKey(e, n);
    encrypto.keyPair = zotKeyPair;
  }

  /// returns decrypted message
  String decrypt(String val) {
    return String.fromCharCodes(ZotPublicKey.writeBigInt(
        (ZotPublicKey.readBytes(const Base64Decoder().convert(val)) * _d) %
            _on));
  }

  /// returns info about private key: the information contains:
  /// 1. algo, 2. modulus, 3. private exponent
  @override
  String toString() {
    // TODO: implement toString
    return "Algo: RSA\nmodulus: ${_on.toString()}\nprivate exponent: ${_d.toString()}";
  }

  /// to make sure generated numbers works properly.
  void _assetEq(BigInt bigInt) {
    if (bigInt.toInt() != 1) {
      throw Exception("defect in generating keys.");
    }
  }
}
