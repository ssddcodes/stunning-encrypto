import 'dart:convert';

import 'package:encrypto_flutter/encryptospi.dart';
import 'package:encrypto_flutter/zot_public_key.dart';

import 'keypair.dart';

class Encrypto {
  static const String RSA = "RSA", DES = "DES";
  int bitLength;
  late final String _algo;
  String pw;
  late EncryptoSpi _ei;
  late ZotKeyPair keyPair;

  /// @param algo "RSA" and "DES" are only supported currently.
  /// @param bitLength it's the keysize that's used to generate keys for encryption/decryption
  /// @param password mandatory to pass password for encryption/decryption, and it's suggested to pass the hash of the password instead of plain text
  Encrypto(this._algo, {this.bitLength = 1024, this.pw = ''}) {
    _init();
  }

  /// it initiates required classes and values for the selected ALGORITHM
  void _init() {
    String link = "https://github.com/ssddcodes/encrypto/";
    if (_algo.toUpperCase() == DES) {
      if (pw.isEmpty || pw.length < 8) {
        throw Exception(
            "Password can't be null or less then 8 characters long for DES encryption. Please pass the password as 2nd argument. Please refer: $link");
      }
      //TODO
    } else if (_algo.toUpperCase() == RSA) {
      _ei = ZotKeyPair(bitLength, this);
    }
  }

  /// sends back the respective public key
  ZotPublicKey getPublicKey() {
    return keyPair.publicKey;
  }

  /// used to convert the client's public key to the ZotPublicKey class instance.
  ZotPublicKey desterilizePublicKey(String base64PublicKey) {
    var obj = jsonDecode(
        String.fromCharCodes(const Base64Decoder().convert(base64PublicKey)));
    return ZotPublicKey(
        BigInt.parse(obj['pe'].toString()), BigInt.parse(obj['on'].toString()));
  }

  /// returns sterilized public key to be sent to the client.
  String sterilizePublicKey() {
    String returnPublicKeyB64 = keyPair.publicKey.sterilizePublicKey();
    if (returnPublicKeyB64.isEmpty) {
      return "null";
    }
    return returnPublicKeyB64;
  }

  /// returns private key string

  String getPrivateKeyString() {
    String x = _ei.getPrivateKeyString();
    if (x == "null") {
      throw Exception(
          'there are no keys ever used for DES local file encryption');
    }
    return x;
  }

  /// returns public key string

  String getPublicKeyString() {
    String x = _ei.getPublicKeyString();
    if (x == ("null")) {
      throw Exception(
          'there are no keys ever used for DES local file encryption');
    }
    return x;
  }

  /// encrypt the message using public key or password.

  String encrypt(String value, {ZotPublicKey? publicKey}) {
    return _ei.encrypt(value, publicKey);
  }

  /// decrypt the encrypted message

  String decrypt(String value) {
    return _ei.decrypt(value);
  }
}
