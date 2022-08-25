import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:encrypto_flutter/encryptospi.dart';
import 'package:encrypto_flutter/zot_private_key.dart';
import 'package:encrypto_flutter/zot_public_key.dart';

class ZotKeyPair extends EncryptoSpi {
  late ZotPrivateKey _privateKey; // private key instance
  late ZotPublicKey publicKey; // public key instance

  ZotKeyPair(int bitLen, Encrypto encrypto) {
    _privateKey = ZotPrivateKey(bitLen, this, encrypto);
  }

  /// returns decrypted message
  @override
  String decrypt(String val) {
    return _privateKey.decrypt(val);
  }

  /// returns rsa encrypted base64 string
  @override
  String encrypt(String val, ZotPublicKey? publicKey) {
    if (publicKey == null) {
      throw Exception("ZotPublicKey can't be null for RSA encryption");
    }
    return publicKey.encrypt(val);
  }

  /// returns info about private key: the information contains:
  /// 1. algo, 2. modulus, 3. private exponent (NEVER share your private exponent)
  @override
  String getPrivateKeyString() {
    return _privateKey.toString();
  }

  /// returns info about public key: the information contains:
  /// 1. algo, 2. modulus, 3. public exponent
  @override
  String getPublicKeyString() {
    return publicKey.toString();
  }
}
