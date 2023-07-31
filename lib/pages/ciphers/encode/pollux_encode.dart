import 'package:flutter/material.dart';

import '../../../services/ciphers/pollux_manager.dart';
import '../../../services/encode_screen_manager.dart';
import '../../../services/language.dart';

class PolluxEncode extends StatefulWidget {
  const PolluxEncode({super.key});

  @override
  State<PolluxEncode> createState() => _PolluxEncodeState();
}

class _PolluxEncodeState extends State<PolluxEncode> {
  @override
  Widget build(BuildContext context) {
    return const EncodeScreenManager(
      setEncodePlaintext: PolluxManager.setEncodePlaintext,
      getUsingCustomKey: null,
      setUsingCustomKey: null,
      getEncodeK1: null,
      setEncodeK1: null,
      appendToKey: null,
      language: Language.english,
      morse: true,
      hill: false
    );
  }
}