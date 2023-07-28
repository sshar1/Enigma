import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/ciphers/aristocrat_manager.dart';

class AristocratEncode extends StatelessWidget {
  const AristocratEncode({super.key});

  static List textCards = [];
  static List focusNodes = [];

  void nextNode(FocusNode current) {
    if (focusNodes.indexOf(current) == focusNodes.length) return;
    for (int i = focusNodes.indexOf(current) + 1; i < focusNodes.length; ++i) {
      if (focusNodes[i].canRequestFocus) {
        focusNodes[i].requestFocus();
        return;
      }
    }
  }

  void previousNode(FocusNode current) {
    if (focusNodes.indexOf(current) == 0) return;
    for (int i = focusNodes.indexOf(current) - 1; i >= 0; --i) {
      if (focusNodes[i].canRequestFocus) {
        focusNodes[i].requestFocus();
        return;
      }
    }
  }

  FocusNode getCurrentFocused() {
    for (FocusNode node in focusNodes) {
      if (node.hasFocus) {
        return node;
      }
    }
    return focusNodes[0];
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    textCards.clear();

    // ignore: invalid_use_of_visible_for_testing_member
    ServicesBinding.instance.keyboard.clearState();
    ServicesBinding.instance.keyboard.addHandler((KeyEvent event) {
      final key = event.logicalKey.keyLabel;

      if (event is KeyDownEvent) {
        if (key == 'Arrow Right') {
          nextNode(getCurrentFocused());
        }
        if (key == 'Arrow Left') {
          previousNode(getCurrentFocused());
        }
      }
      return false;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Enter a plaintext",
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 25
            )
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z' ,.]")),
          ],
          controller: controller,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          maxLength: 400,
          cursorColor: Colors.grey[100],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Enter Plaintext',
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
          onChanged: (value) => AristocratManager.encodePlaintext = controller.text,
        ),
        const SizedBox(height: 20),
        KeyList(
          textCards: textCards,
          focusNodes: focusNodes
        )
      ],
    );
  }
}

class KeyList extends StatefulWidget {
  final List textCards;
  final List focusNodes;
  const KeyList({super.key, required this.textCards, required this.focusNodes});

  @override
  State<KeyList> createState() => _KeyListState();
}

class _KeyListState extends State<KeyList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(
            "Use Custom Key",
            style: TextStyle(
              fontFamily: 'Ysabeau',
              color: Colors.grey[100],
              fontSize: 20
            )
          ),
          value: AristocratManager.usingCustomKey, 
          onChanged: (bool value) {
            setState(() {
              AristocratManager.usingCustomKey = value;
            });
          },
          activeColor: Colors.grey[100],
          activeTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.grey[600],
          inactiveTrackColor: Colors.grey[800],
        ),
        if (!AristocratManager.usingCustomKey) SwitchListTile(
          title: Text(
            "K1 encrypt",
            style: TextStyle(
              fontFamily: 'Ysabeau',
              color: Colors.grey[100],
              fontSize: 20
            )
          ),
          value: AristocratManager.encodeK1, 
          onChanged: (bool value) {
            setState(() {
              AristocratManager.encodeK1 = value;
            });
          },
          activeColor: Colors.grey[100],
          activeTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.grey[600],
          inactiveTrackColor: Colors.grey[800],
        ),
        const SizedBox(height: 20),
        if (AristocratManager.usingCustomKey) LetterList(textCards: widget.textCards, focusNodes: widget.focusNodes)
      ],
    );
  }
}

class LetterList extends StatelessWidget {
  final List textCards;
  final List focusNodes;
  const LetterList({super.key, required this.textCards, required this.focusNodes});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: AristocratManager.letters.map((letter) => Column(
        children: [
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
                child: Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.grey[100],
                )
              )
            )
          ),
          LetterTextField(plaintext: letter, textCards: textCards, focusNodes: focusNodes),
          const SizedBox(width: 10,)
        ],
      )).toList()
    );
  }
}

class LetterTextField extends StatefulWidget {
  final String plaintext;
  final List textCards;
  final List focusNodes;
  const LetterTextField({super.key, required this.plaintext, required this.textCards, required this.focusNodes});

  @override
  State<LetterTextField> createState() => _LetterTextFieldState();
}

class _LetterTextFieldState extends State<LetterTextField> {

  final FocusNode _focus = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.focusNodes.add(_focus);

    controller.addListener(() {
      final String text = controller.text.contains(RegExp(r'^[a-zA-Z]+$')) ? controller.text.toUpperCase() : '';
      controller.value = controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    widget.focusNodes.remove(_focus);
    _focus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      shape: const LinearBorder(),
      margin: const EdgeInsets.only(),
      color: Colors.grey[850],
      elevation: 2,
      child: SizedBox(
        width: 35,
        height: 30,
        child: Center(
          child: TextField(
            controller: controller,
            focusNode: _focus,
            showCursor: false,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.only(bottom: 15, left: 2), // padding of 2 because it doesn't center for some reason
              counterText: '',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)
              )
            ), 
            style: TextStyle(
              color: Colors.grey[100],
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) => AristocratManager.encodeKey[widget.plaintext] = value,
          )
        )
      )
    );

    widget.textCards.add(this,);

    return card;
  }
}