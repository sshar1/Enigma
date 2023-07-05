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

    return const Column(
      children: [
        CharacterCardManager(marginTotal: 100),
        SizedBox(height: 50),
        CharacterList()
      ],
    );
  }
}