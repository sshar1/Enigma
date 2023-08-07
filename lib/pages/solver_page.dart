import 'package:flutter/material.dart';

import '../services/solver/breaker.dart';

class SolverPage extends StatelessWidget {
  const SolverPage({super.key});

  static const List letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text(
          "Aristocrat Solver",
          style: TextStyle(
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
                const Expanded(
                  child: ListTile(tileColor: Colors.transparent,)
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    if (getValidLength(controller.text) > 20) {
                      var breaker = await Breaker.init();
                      Map breakerInfo = breaker.breakCipher(controller.text);
                       // ignore: use_build_context_synchronously
                      _dialogBuilder(context, breakerInfo);
                    }
                  },
                  child: const Text("Break!"),
                )
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: null,
              maxLength: 500,
              cursorColor: Colors.grey[100],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Enter Ciphertext',
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
            ),
          ],
        )
      )
    );
  }

  int getValidLength(String text) {
    int count = 0;
    for (String char in text.toUpperCase().split('')) {
      if (letters.contains(char)) {
        count++;
      }
    }
    return count;
  }

  Future<void> _dialogBuilder(BuildContext context, Map info) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Cracked in ${info['seconds']} seconds',
            style: const TextStyle(
              color: Colors.white
            )
          ),
          content: Text(
            '${breakText(info['plaintext'])}\n\nKey: ${info['key']}\nFitness Score: ${info['fitness']}',
            style: const TextStyle(
              color: Colors.white
            )
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                },
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.grey[900]
                  )
                ),
              ),
            )
          ],
        );
      },
    );
  }

  String breakText(String text) {
    String result = "";
    int characters = 0;

    for (String char in text.split(' ')) {
      if (char.length + characters > 50) {
        result += '\n$char ';
        characters = 0;
      } else {
        result += '$char ';
      }
      characters += char.length;
    }

    return result;
  }
}