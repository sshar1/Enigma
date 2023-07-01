import 'package:flutter/material.dart';
import 'package:myapp/services/character_card_manager.dart';

import '../../../services/character_list.dart';

class AristocratEncode extends StatefulWidget {
  const AristocratEncode({super.key});

  @override
  State<AristocratEncode> createState() => _AristocratEncodeState();
}

class _AristocratEncodeState extends State<AristocratEncode> {

  String quote = "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin but by the content of their character.";

  @override
  Widget build(BuildContext context) {
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
          CharacterCardManager(text: quote, marginTotal: 100),
          const SizedBox(height: 50),
          const CharacterList()
        ],
      )
    );
  }
}