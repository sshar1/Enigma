import 'package:flutter/material.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';
import 'package:myapp/services/ciphers/xenocrypt_manager.dart';
import 'package:myapp/services/language.dart';

class CharacterList extends StatelessWidget {
  final Map frequencies;
  final Map userKey;
  final Language language;
  const CharacterList({super.key, required this.frequencies, required this.userKey, required this.language});

  static final Map replacementCardStates = {};

  @override
  Widget build(BuildContext context) {
    final List letters = (language == Language.english) ? AristocratManager.letters : XenocryptManager.letters;
    resetReplacementCards(letters);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) => Column(
        children: [
          Card(
            shape: LinearBorder.bottom(side: BorderSide(color: Colors.grey[100]!)),
            margin: const EdgeInsets.only(),
              color: Colors.grey[850],
              elevation: 2,
              child: SizedBox(
                width: 35,
                height: 30,
                child: Center(
                  child: Text(
                    letter, 
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              )
          ),
          Card(
            shape: const LinearBorder(),
            margin: const EdgeInsets.only(),
              color: Colors.grey[850],
              elevation: 2,
              child: SizedBox(
                width: 35,
                height: 30,
                child: Center(
                  child: Text(
                    frequencies[letter] == 0 ? '' : frequencies[letter].toString(),
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              )
          ),
          Replacement(letter: letter, userKey: userKey)
        ],
      )).toList()
    );
  }

  static void resetReplacementCards(List letters) {
    for (String letter in letters) {
      replacementCardStates[letter] = '';
    }
  }
}

class Replacement extends StatefulWidget {
  final String letter; // Ciphertext letter
  final Map userKey;
  const Replacement({super.key, required this.letter, required this.userKey});

  @override
  State<Replacement> createState() => ReplacementState();
}

class ReplacementState extends State<Replacement> {

  void callback() {
    setState(() {
      // print('test ${widget.letter}');
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      shape: LinearBorder.top(side: BorderSide(color: Colors.grey[100]!)),
      margin: const EdgeInsets.only(),
        color: Colors.grey[850],
        elevation: 2,
        child: SizedBox(
          width: 35,
          height: 30,
          child: Center(
            child: Text(
              getText(),
              style: TextStyle(
                color: Colors.grey[100],
                fontWeight: FontWeight.bold
              ),
            )
          )
        )
    );

    CharacterList.replacementCardStates[widget.letter] = this;

    return card;
  }

  String getText() {
    for (String plaintext in widget.userKey.keys) {
      if (widget.userKey[plaintext].length == 0) continue;

      if (widget.userKey[plaintext][0] == widget.letter) {
        return plaintext;
      }
    }
    return '';
  }
}