import 'package:flutter/material.dart';

import '../../../services/ciphers/pollux_manager.dart';
import '../../../services/morse_card_manager.dart';

class PolluxDecode extends StatefulWidget {
  const PolluxDecode({super.key});

  @override
  State<PolluxDecode> createState() => _PolluxDecodeState();
}

class _PolluxDecodeState extends State<PolluxDecode> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            PolluxManager.getTitle(),
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        MorseCardManager(marginTotal: 100, ciphertext: PolluxManager.ciphertext,),
        const SizedBox(height: 50),
      ],
    );
  }
}