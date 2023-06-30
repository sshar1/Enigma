import 'package:flutter/material.dart';

class CipherPage extends StatefulWidget {
  const CipherPage({super.key});

  @override
  State<CipherPage> createState() => _CipherPageState();
}

class _CipherPageState extends State<CipherPage> {
  Map data = {};

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;
    String pageTitle = data['encoding'] ? 'Encoder' : 'Decoder';

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Text(
          "${data['name']} $pageTitle",
          style: const TextStyle(
            fontFamily: 'Belanosima',
            fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        ),
        elevation: 0,
      ),
      body: data['page']
    );
  }
}