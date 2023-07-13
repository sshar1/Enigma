import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/ciphers/morbit_manager.dart';
import '../../../services/morse_card_manager.dart';

class MorbitDecode extends StatefulWidget {
  const MorbitDecode({super.key});

  @override
  State<MorbitDecode> createState() => _MorbitDecodeState();
}

class _MorbitDecodeState extends State<MorbitDecode> {

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      final String text = controller.text;
      controller.value = controller.value.copyWith(
        text: text.toUpperCase(),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            MorbitManager.getTitle(),
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        MorseCardManager(marginTotal: 100, ciphertext: MorbitManager.ciphertext, isMorbit: true),
        const SizedBox(height: 50),
        TextField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z' ]")),
          ],
          controller: controller,
          maxLength: 100,
          cursorColor: Colors.grey[100],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Enter Plaintext',
            labelStyle: TextStyle(
              color: Colors.grey[100]
            ),
            counterStyle: TextStyle(
              color: Colors.grey[100]
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[100]!)
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[800]!)
            ),
          ),
          style: TextStyle(
            color: Colors.grey[100],
          ),
          onChanged: (text) => {
            MorbitManager.userAnswer = text
          },
        )
      ],
    );
  }
}