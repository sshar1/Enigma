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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: const Text(
                      "3:24",
                      style: TextStyle(
                        fontFamily: 'Ysabeau',
                        fontSize: 20
                      ),
                    ),
                    tileColor: Colors.transparent,
                    iconColor: Colors.grey[100],
                    textColor: Colors.grey[100],
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                  ),
                  onPressed: () {
                    print('test');
                  },
                  child: const Text("Submit"),
                )
              ],
            ),
            const SizedBox(height: 20),
            data['page']
          ],
        )
      )
    );
  }
}