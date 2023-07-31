import 'package:flutter/material.dart';

import '../../../services/ciphers/xenocrypt_manager.dart';
import '../../../services/encode_screen_manager.dart';
import '../../../services/language.dart';

class XenocryptEncode extends StatefulWidget {
  const XenocryptEncode({super.key});

  @override
  State<XenocryptEncode> createState() => _XenocryptEncodeState();
}

class _XenocryptEncodeState extends State<XenocryptEncode> {
  @override
  Widget build(BuildContext context) {
    return const EncodeScreenManager(
      setEncodePlaintext: XenocryptManager.setEncodePlaintext,
      getUsingCustomKey: XenocryptManager.getUsingCustomKey,
      setUsingCustomKey: XenocryptManager.setUsingCustomKey,
      getEncodeK1: XenocryptManager.getEncodeK1,
      setEncodeK1: XenocryptManager.setEncodeK1,
      appendToKey: XenocryptManager.appendToKey,
      language: Language.spanish,
      morse: false
    );
  }
}