import 'package:encrypto_flutter/encrypto_flutter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String encryptedAndDecrypted = '';
  bool _isEditingText = true;
  late TextEditingController controller;
  late Encrypto encrypto;

  @override
  void initState() {
    // TODO: implement initState
    controller = TextEditingController();
    encrypto = Encrypto(Encrypto.RSA, bitLength: 1024);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            _editTitleTextField(),
            ElevatedButton(
                onPressed: () {
                  // encrypts the message using self generate public key
                  //
                  // you can also generate base64 public key string to be sent to the client by:
                  // var publicKeyToBeSent = encrypto.sterilizePublicKey();
                  // print(publicKeyToBeSent); //prints eyJwZSI6OTIyMzM3MjAzNjg1NDc3NTgwNywib24iOjkyMjMzNzIwMzY4NTQ3NzU4MDd9
                  //
                  // in order to de-sterilize the client's public key you can use:
                  // var publicKey = encrypto.desterilizePublicKey('eyJwZSI6OTIyMzM3MjAzNjg1NDc3NTgwNywib24iOjkyMjMzNzIwMzY4NTQ3NzU4MDd9');
                  // now you can use this publicKey for encryption like:
                  // encrypto.encrypt('foo',publicKey: publicKey);

                  var encrypted = encrypto.encrypt(controller.text,
                      publicKey: encrypto.getPublicKey());
                  var decrypted = encrypto.decrypt(encrypted);
                  setState(() {
                    encryptedAndDecrypted =
                        'encrypted base64 String: $encrypted\ndecrypted String: $decrypted';
                  });
                },
                child: const Text("Encrypt and Decrypt")),
            Text(encryptedAndDecrypted),
          ],
        ),
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText) {
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              encryptedAndDecrypted = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: controller,
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
          encryptedAndDecrypted,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
