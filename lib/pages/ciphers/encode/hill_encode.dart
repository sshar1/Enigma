import 'package:flutter/material.dart';

import '../../../services/ciphers/hill_manager.dart';
import '../../../services/encode_screen_manager.dart';
import '../../../services/language.dart';

class HillEncode extends StatefulWidget {
  const HillEncode({super.key});

  @override
  State<HillEncode> createState() => _HillEncodeState();
}

class _HillEncodeState extends State<HillEncode> {
  @override
  Widget build(BuildContext context) {
    return const EncodeScreenManager(
      setEncodePlaintext: HillManager.setEncodePlaintext,
      getUsingCustomKey: null,
      setUsingCustomKey: null,
      getEncodeK1: null,
      setEncodeK1: null,
      appendToKey: null,
      language: Language.english,
      morse: true,
      hill: true
    );
  }
}