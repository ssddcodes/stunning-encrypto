import 'dart:developer';

import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String encryptedString = '', decyptedString = '';
  bool _isEditingText = true;
  late List<TextEditingController> controllers;
  late Encrypto encrypto;

  @override
  void initState() {
    controllers = [];
    for (int i = 0; i < 3; i++) {
      controllers.add(TextEditingController());
    }

    encrypto = Encrypto(Encrypto.RSA, bitLength: 128);
    log(encrypto.sterilizePublicKey()); //enter this in 1st field while testing
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            _editTitleTextField(0), //enter ZotPublicKey sterilized string
            _editTitleTextField(1), //enter message to encrypt
            _editTitleTextField(2), //enter encrypted message to decrypt
            ElevatedButton(
                onPressed: () {
                  // encrypts the message using self generate public key
                  //
                  // you can also generate base64 public key string to be sent to the client by:
                  // var publicKeyToBeSent = encrypto.sterilizePublicKey();
                  // print(publicKeyToBeSent); //prints eyJwZSI6OTIyMzM3MjAzNjg1NDc3NTgwNywib24iOjkyMjMzNzIwMzY4NTQ3NzU4MDd9
                  //
                  // in order to de-sterilize the client's public key you can use:
                  // now you can use this publicKey for encryption like:
                  setState(() {
                    if (controllers[2].text.isNotEmpty) {
                      decyptedString = encrypto.decrypt(controllers[2].text);
                      encryptedString = '';
                    }
                    if (controllers[1].text.isNotEmpty) {
                      if (controllers[0].text.isNotEmpty) {
                        encryptedString = encrypto.encrypt(controllers[1].text,
                            publicKey: Encrypto.desterilizePublicKey(
                                controllers[0].text));
                      } else {
                        encryptedString = encrypto.encrypt(controllers[1].text,
                            publicKey: encrypto.getPublicKey());
                      }
                    }
                  });
                },
                child: const Text("Encrypt and Decrypt")),
            ElevatedButton(
              child: Text(encryptedString.isNotEmpty &&
                      decyptedString.isNotEmpty
                  ? 'Decrypted: $decyptedString\nEncrypted: $encryptedString'
                  : encryptedString.isEmpty
                      ? 'Decrypted: $decyptedString'
                      : 'Encrypted: $encryptedString'),
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text: encryptedString.isNotEmpty &&
                            decyptedString.isNotEmpty
                        ? 'Decrypted: $decyptedString Encrypted: $encryptedString'
                        : encryptedString.isEmpty
                            ? decyptedString
                            : encryptedString));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _editTitleTextField(int i) {
    if (_isEditingText) {
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              encryptedString = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: controllers[i],
        ),
      );
    }
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          encryptedString,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
