import 'package:encrypto_flutter/zot_public_key.dart';

abstract class EncryptoSpi {
  /// notifies the class to encrypt the message and return base64 string
  /// NOTE: you do not need to pass public key for DES encryption
  String encrypt(String val, ZotPublicKey? publicKey);

  /// notifies the class to decrypt the message and return value
  String decrypt(String val);

  /// returns ZotPublicKey string
  String getPublicKeyString();

  /// returns ZotPrivateKey string
  String getPrivateKeyString();
}
