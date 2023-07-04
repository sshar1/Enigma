import 'package:flutter/material.dart';
import 'package:myapp/services/character_card_manager.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';

import '../../../services/character_list.dart';

class AristocratEncode extends StatelessWidget {
  const AristocratEncode({super.key});

  void setupAristocrat() async {
    await AristocratManager.nextAristocrat();
  }

  @override
  Widget build(BuildContext context) {
    setupAristocrat();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.access_time),
            title: const Text(
              "3:24",
              style: TextStyle(
                fontFamily: 'Ysabeau',
                fontSize: 20
              ),
            ),
            tileColor: Colors.transparent,
            iconColor: Colors.grey[100],
            textColor: Colors.grey[100],
          ),
          const SizedBox(height: 20),
          const CharacterCardManager(marginTotal: 100),
          const SizedBox(height: 50),
          const CharacterList()
        ],
      )
    );
  }
}