import 'package:flutter/material.dart';

import 'package:myapp/pages/ciphers/decode/aristocrat_decode.dart';
import 'package:myapp/pages/ciphers/decode/hill_decode.dart';
import 'package:myapp/pages/ciphers/decode/morbit_decode.dart';
import 'package:myapp/pages/ciphers/decode/patristocrat_decode.dart';
import 'package:myapp/pages/ciphers/decode/pollux_decode.dart';
import 'package:myapp/pages/ciphers/encode/aristocrat_encode.dart';
import 'package:myapp/pages/ciphers/encode/hill_encode.dart';
import 'package:myapp/pages/ciphers/encode/morbit_encode.dart';
import 'package:myapp/pages/ciphers/encode/patristocrat_encode.dart';
import 'package:myapp/pages/ciphers/encode/pollux_encode.dart';
import 'package:myapp/pages/ciphers/encode/xenocrypt_encode.dart';
import 'package:myapp/services/cipher_type.dart';

import '../services/cipher_info.dart';
import 'ciphers/decode/xenocrypt_decode.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CipherInfo> ciphers = [
    CipherInfo(
      name: 'Aristocrat', 
      image: 'cork2.png', 
      description: 'A simple monoalphabetic substitution cipher where each ciphertext letter corresponds to a plaintext letter. '
      'A ciphertext letter cannot correspond to the same plaintext letter.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const AristocratEncode(), CipherType.decode : const AristocratDecode()}
    ),
    CipherInfo(
      name: 'Patristocrat', 
      image: 'cork2.png', 
      description: 'The same encryption pattern as the aristocrat cipher, but spaces in the ciphertext do not correspond to '
      'spaces in the plaintext. A space in the ciphertext is shown every 5 characters.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const PatristocratEncode(), CipherType.decode : const PatristocratDecode()}
    ),
    CipherInfo(
      name: 'Xenocrypt', 
      image: 'cork2.png', 
      description: 'The sample encryption pattern as the aristocrat cipher, but the plaintext is in Spanish. There is an additional '
      'letter: ñ', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const XenocryptEncode(), CipherType.decode : const XenocryptDecode()}
    ),
    CipherInfo(
      name: 'Pollux', 
      image: 'cork2.png', 
      description: 'A cipher in which the plaintext is converted into a string of numbers 0-9. Each number corresponds to x, ., or - '
      'in morse code.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const PolluxEncode(), CipherType.decode : const PolluxDecode()}
    ),
    CipherInfo(
      name: 'Morbit', 
      image: 'cork2.png', 
      description: 'The sample encryption patter as the pollux cipher, but each number corresponds to 2 morse characters (eg. x- or .-).', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const MorbitEncode(), CipherType.decode : const MorbitDecode()}
    ),
    CipherInfo(
      name: 'Hill', 
      image: 'cork2.png', 
      description: 'A cipher that is solved using a key 2x2 matrix. The rules are complex so read the sci oly wiki page for more info.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const HillEncode(), CipherType.decode : const HillDecode()}
      ),
  ];

  bool _encoding = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          'Enigma',
          style: TextStyle(
            fontFamily: 'Belanosima',
            fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text(
                _encoding ? "Encoding" : "Decoding",
                style: TextStyle(
                  fontFamily: 'Ysabeau',
                  color: Colors.grey[100],
                  fontSize: 20
                )
              ),
              value: _encoding, 
              onChanged: (bool value) {
                setState(() {
                  _encoding = value;
                });
              },
              secondary: Icon(
                _encoding ? Icons.password : Icons.key,
                color: Colors.grey[100],
                size: 30,
              ),
              activeColor: Colors.grey[100],
              activeTrackColor: Colors.grey[400],
              inactiveThumbColor: Colors.grey[100],
              inactiveTrackColor: Colors.grey[400],
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: ciphers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ListTile(
                    onTap: () {
                      Widget page = _encoding ? ciphers[index].pages[CipherType.encode] : ciphers[index].pages[CipherType.decode];
                      Navigator.pushNamed(context, '/cipherpage', arguments: {'name' : ciphers[index].name, 'encoding' : _encoding, 'page' : page});
                    },
                    title: Text(
                      ciphers[index].name,
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Ysabeau'
                      )
                    ),
                    subtitle: Text(
                      ciphers[index].description,
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontFamily: 'Ysabeau'
                      )
                    ),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/${ciphers[index].image}')
                    ),
                    tileColor: ciphers[index].color,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    isThreeLine: true,
                  ),
                );
              }
            ),
          ],
        ),
      )
    );
  }
}