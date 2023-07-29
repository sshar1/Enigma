import 'package:flutter/material.dart';

import '../../../services/ciphers/patristocrat_manager.dart';
import '../../../services/encode_screen_manager.dart';
import '../../../services/language.dart';

class PatristocratEncode extends StatelessWidget {
  const PatristocratEncode({super.key});

  @override
  Widget build(BuildContext context) {
    return const EncodeScreenManager(
      setEncodePlaintext: PatristocratManager.setEncodePlaintext,
      getUsingCustomKey: PatristocratManager.getUsingCustomKey,
      setUsingCustomKey: PatristocratManager.setUsingCustomKey,
      getEncodeK1: PatristocratManager.getEncodeK1,
      setEncodeK1: PatristocratManager.setEncodeK1,
      appendToKey: PatristocratManager.appendToKey,
      language: Language.english,
    );
  }
}