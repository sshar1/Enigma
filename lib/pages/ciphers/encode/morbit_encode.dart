import 'package:flutter/material.dart';

import '../../../services/ciphers/morbit_manager.dart';
import '../../../services/encode_screen_manager.dart';
import '../../../services/language.dart';

class MorbitEncode extends StatefulWidget {
  const MorbitEncode({super.key});

  @override
  State<MorbitEncode> createState() => _MorbitEncodeState();
}

class _MorbitEncodeState extends State<MorbitEncode> {
  @override
  Widget build(BuildContext context) {
    return const EncodeScreenManager(
      setEncodePlaintext: MorbitManager.setEncodePlaintext,
      getUsingCustomKey: null,
      setUsingCustomKey: null,
      getEncodeK1: null,
      setEncodeK1: null,
      appendToKey: null,
      language: Language.english,
      morse: true
    );
  }
}