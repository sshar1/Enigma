import 'package:flutter/material.dart';

import '../../../services/ciphers/hill_manager.dart';
import '../../../services/hill_card_manager.dart';

class HillDecode extends StatefulWidget {
  const HillDecode({super.key});

  @override
  State<HillDecode> createState() => _HillDecodeState();
}

class _HillDecodeState extends State<HillDecode> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            HillManager.getTitle(),
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        HillCardManager(marginTotal: 100, ciphertext: HillManager.ciphertext),
        const SizedBox(height: 50),
      ],
    );
  }
}