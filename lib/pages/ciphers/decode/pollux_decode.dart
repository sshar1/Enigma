import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/ciphers/pollux_manager.dart';
import '../../../services/morse_card_manager.dart';

class PolluxDecode extends StatefulWidget {
  const PolluxDecode({super.key});

  @override
  State<PolluxDecode> createState() => _PolluxDecodeState();
}

class _PolluxDecodeState extends State<PolluxDecode> {

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
            PolluxManager.userAnswer = text
          },
        )
      ],
    );
  }
}