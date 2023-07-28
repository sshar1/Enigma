import 'package:flutter/material.dart';
import 'package:enigma/services/ciphers/patristocrat_manager.dart';

import '../../../services/character_card_manager.dart';
import '../../../services/character_list.dart';
import '../../../services/language.dart';

class PatristocratDecode extends StatefulWidget {
  const PatristocratDecode({super.key});

  @override
  State<PatristocratDecode> createState() => _PatristocratDecodeState();
}

class _PatristocratDecodeState extends State<PatristocratDecode> {
  @override
  Widget build(BuildContext context) {
    print(PatristocratManager.ciphertext);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            PatristocratManager.getTitle(),
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        CharacterCardManager(marginTotal: 100, userKey: PatristocratManager.userKey, ciphertext: PatristocratManager.ciphertext, language: Language.english,),
        const SizedBox(height: 50),
        CharacterList(frequencies: PatristocratManager.frequencies, userKey: PatristocratManager.userKey, language: Language.english)
      ],
    );
  }
}