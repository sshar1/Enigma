import 'package:flutter/material.dart';

import 'package:enigma/pages/ciphers/decode/aristocrat_decode.dart';
import 'package:enigma/pages/ciphers/decode/hill_decode.dart';
import 'package:enigma/pages/ciphers/decode/morbit_decode.dart';
import 'package:enigma/pages/ciphers/decode/patristocrat_decode.dart';
import 'package:enigma/pages/ciphers/decode/pollux_decode.dart';
import 'package:enigma/pages/ciphers/encode/aristocrat_encode.dart';
import 'package:enigma/pages/ciphers/encode/hill_encode.dart';
import 'package:enigma/pages/ciphers/encode/morbit_encode.dart';
import 'package:enigma/pages/ciphers/encode/patristocrat_encode.dart';
import 'package:enigma/pages/ciphers/encode/pollux_encode.dart';
import 'package:enigma/pages/ciphers/encode/xenocrypt_encode.dart';
import 'package:enigma/services/cipher_type.dart';
import 'package:enigma/services/ciphers/morbit_manager.dart';
import 'package:enigma/services/ciphers/patristocrat_manager.dart';

import '../services/cipher_info.dart';
import '../services/ciphers/aristocrat_manager.dart';
import '../services/ciphers/hill_manager.dart';
import '../services/ciphers/pollux_manager.dart';
import '../services/ciphers/xenocrypt_manager.dart';
import 'ciphers/decode/xenocrypt_decode.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // TODO everything has temporarily been given an aristocrat manager encode function
  List<CipherInfo> ciphers = [
    CipherInfo(
      name: 'Aristocrat', 
      image: 'cork2.png', 
      description: 'A simple monoalphabetic substitution cipher where each ciphertext letter corresponds to a plaintext letter. '
      'A ciphertext letter cannot correspond to the same plaintext letter.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const AristocratEncode(), CipherType.decode : const AristocratDecode()},
      checkWin: AristocratManager.keysMatch,
      getPlaintext: AristocratManager.getPlaintext,
      nextCipher: AristocratManager.next,
      encode: AristocratManager.encode,
      getEncodeCiphertext: AristocratManager.getEncodingCiphertext,
      encodeReady: AristocratManager.encodeReady,
      clearEncodingVariables: AristocratManager.clearEncodingVariables,
    ),
    CipherInfo(
      name: 'Patristocrat', 
      image: 'cork2.png', 
      description: 'The same encryption pattern as the aristocrat cipher, but spaces in the ciphertext do not correspond to '
      'spaces in the plaintext. A space in the ciphertext is shown every 5 characters. Most are K1.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const PatristocratEncode(), CipherType.decode : const PatristocratDecode()},
      checkWin: PatristocratManager.keysMatch,
      getPlaintext: PatristocratManager.getPlaintext,
      nextCipher: PatristocratManager.next,
      encode: PatristocratManager.encode,
      getEncodeCiphertext: PatristocratManager.getEncodingCiphertext,
      encodeReady: PatristocratManager.encodeReady,
      clearEncodingVariables: PatristocratManager.clearEncodingVariables,
    ),
    CipherInfo(
      name: 'Xenocrypt', 
      image: 'cork2.png', 
      description: 'The sample encryption pattern as the aristocrat cipher, but the plaintext is in Spanish. There is an additional '
      'letter: ñ. Press \'1\' to enter it. Most are K1.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const XenocryptEncode(), CipherType.decode : const XenocryptDecode()},
      checkWin: XenocryptManager.keysMatch,
      getPlaintext: XenocryptManager.getPlaintext,
      nextCipher: XenocryptManager.next,
      encode: XenocryptManager.encode,
      getEncodeCiphertext: XenocryptManager.getEncodingCiphertext,
      encodeReady: XenocryptManager.encodeReady,
      clearEncodingVariables: XenocryptManager.clearEncodingVariables,
    ),
    CipherInfo(
      name: 'Pollux', 
      image: 'cork2.png', 
      description: 'A cipher in which the plaintext is converted into a string of numbers 0-9. Each number corresponds to x, ., or - '
      'in morse code.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const PolluxEncode(), CipherType.decode : const PolluxDecode()},
      checkWin: PolluxManager.checkWin,
      getPlaintext: PolluxManager.getPlaintext,
      nextCipher: PolluxManager.next,
      encode: AristocratManager.encode,
      getEncodeCiphertext: AristocratManager.getEncodingCiphertext,
      encodeReady: AristocratManager.encodeReady,
      clearEncodingVariables: AristocratManager.clearEncodingVariables,
    ),
    CipherInfo(
      name: 'Morbit', 
      image: 'cork2.png', 
      description: 'The sample encryption patter as the pollux cipher, but each number corresponds to 2 morse characters (eg. x- or .-).', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const MorbitEncode(), CipherType.decode : const MorbitDecode()},
      checkWin: MorbitManager.checkWin,
      getPlaintext: MorbitManager.getPlaintext,
      nextCipher: MorbitManager.next,
      encode: AristocratManager.encode,
      getEncodeCiphertext: AristocratManager.getEncodingCiphertext,
      encodeReady: AristocratManager.encodeReady,
      clearEncodingVariables: AristocratManager.clearEncodingVariables,
    ),
    CipherInfo(
      name: 'Hill', 
      image: 'cork2.png', 
      description: 'A cipher that is solved using a key 2x2 matrix. The rules are complex so read the sci oly wiki page for more info.', 
      color: Colors.grey[850]!,
      pages: {CipherType.encode : const HillEncode(), CipherType.decode : const HillDecode()},
      checkWin: HillManager.keysMatch,
      getPlaintext: HillManager.getPlaintext,
      nextCipher: HillManager.next,
      encode: AristocratManager.encode,
      getEncodeCiphertext: AristocratManager.getEncodingCiphertext,
      encodeReady: AristocratManager.encodeReady,
      clearEncodingVariables: AristocratManager.clearEncodingVariables,
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
                    onTap: () async {
                      if (!_encoding) await ciphers[index].nextCipher();
                      if (_encoding) ciphers[index].clearEncodingVariables();
                      Widget page = _encoding ? ciphers[index].pages[CipherType.encode] : ciphers[index].pages[CipherType.decode];
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, '/cipherpage', arguments: {
                        'name' : ciphers[index].name, 
                        'encoding' : _encoding, 
                        'page' : page, 
                        'checkWin' : ciphers[index].checkWin,
                        'plaintext' : ciphers[index].getPlaintext,
                        'encode' : ciphers[index].encode,
                        'encodeCiphertext' : ciphers[index].getEncodeCiphertext,
                        'encodeReady' : ciphers[index].encodeReady
                      });
                    },
                    title: Text(
                      ciphers[index].name,
                      style: TextStyle(
                        color: Colors.grey[100],
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
