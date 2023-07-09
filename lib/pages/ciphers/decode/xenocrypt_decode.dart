import 'package:flutter/material.dart';

import '../../../services/character_card_manager.dart';
import '../../../services/character_list.dart';
import '../../../services/ciphers/xenocrypt_manager.dart';
import '../../../services/language.dart';

class XenocryptDecode extends StatefulWidget {
  const XenocryptDecode({super.key});

  @override
  State<XenocryptDecode> createState() => _XenocryptDecodeState();
}

class _XenocryptDecodeState extends State<XenocryptDecode> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            XenocryptManager.getTitle(),
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        CharacterCardManager(marginTotal: 100, userKey: XenocryptManager.userKey, ciphertext: XenocryptManager.ciphertext, language: Language.spanish,),
        const SizedBox(height: 50),
        CharacterList(frequencies: XenocryptManager.frequencies, userKey: XenocryptManager.userKey, language: Language.spanish)
      ],
    );
  }
}