import 'package:flutter/material.dart';
import 'package:myapp/services/language.dart';

import '../../../services/character_card_manager.dart';
import '../../../services/character_list.dart';
import '../../../services/ciphers/aristocrat_manager.dart';

class AristocratDecode extends StatefulWidget {
  const AristocratDecode({super.key});

  @override
  State<AristocratDecode> createState() => _AristocratDecodeState();
}

class _AristocratDecodeState extends State<AristocratDecode> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AristocratManager.getTitle(),
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        CharacterCardManager(marginTotal: 100, userKey: AristocratManager.userKey, ciphertext: AristocratManager.ciphertext, language: Language.english,),
        const SizedBox(height: 50),
        CharacterList(frequencies: AristocratManager.frequencies, userKey: AristocratManager.userKey, language: Language.english)
      ],
    );
  }
}