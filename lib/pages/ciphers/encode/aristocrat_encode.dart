import 'package:flutter/material.dart';
import 'package:enigma/services/encode_screen_manager.dart';

import '../../../services/ciphers/aristocrat_manager.dart';
import '../../../services/language.dart';

class AristocratEncode extends StatelessWidget {
  const AristocratEncode({super.key});

  @override
  Widget build(BuildContext context) {
    return const EncodeScreenManager(
      setEncodePlaintext: AristocratManager.setEncodePlaintext,
      getUsingCustomKey: AristocratManager.getUsingCustomKey,
      setUsingCustomKey: AristocratManager.setUsingCustomKey,
      getEncodeK1: AristocratManager.getEncodeK1,
      setEncodeK1: AristocratManager.setEncodeK1,
      appendToKey: AristocratManager.appendToKey,
      language: Language.english,
    );
  }
}