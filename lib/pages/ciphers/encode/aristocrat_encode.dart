import 'package:flutter/material.dart';
import 'package:myapp/services/character_card_manager.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';

import '../../../services/character_list.dart';

class AristocratEncode extends StatelessWidget {
  const AristocratEncode({super.key});

  void setupAristocrat() async {
    await AristocratManager.next();
  }

  @override
  Widget build(BuildContext context) {
    setupAristocrat();

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
        const CharacterCardManager(marginTotal: 100),
        const SizedBox(height: 50),
        const CharacterList()
      ],
    );
  }
}