import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ciphers/hill_manager.dart';

class HillCardManager extends StatelessWidget {
  final int marginTotal;
  final String ciphertext;

  const HillCardManager({super.key, required this.marginTotal, required this.ciphertext});

  static Map textControllers = {};
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
    textCards.clear();
    RegExp validLetters = RegExp(r'^[a-zA-Z]+$');

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

    double index = 0;
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Wrap(
        children: ciphertext.split('').map<Widget>((character) => Column(
          children: [
            Card(
              margin: const EdgeInsets.only(),
              color: Colors.grey[850],
              elevation: 2,
              child: SizedBox(
                width: 40,
                height: 50,
                child: Center(
                  child: Text(
                    character, 
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              )
            ),
            const SizedBox(height: 5),
            FocusTraversalOrder(
              order: NumericFocusOrder(index++),
              child: TextCard(
                character: character, 
                textCards: textCards, 
                focusNodes: focusNodes, 
                validLetters: validLetters,
              )
            )
          ],
        )).toList()
      ),
    );
  }

  void addControllers(RegExp validLetters, List letters) {
    for (String letter in letters) {
      TextEditingController controller = TextEditingController();

      controller.addListener(() {
        final String text = controller.text.contains(validLetters) ? controller.text.toUpperCase() : '';
        controller.value = controller.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });

      textControllers[letter] = controller;
    }
  }
}

class TextCard extends StatefulWidget {
  final String character;
  final List textCards;
  final List focusNodes;
  final RegExp validLetters;

  const TextCard({super.key, 
    required this.character, 
    required this.textCards, 
    required this.focusNodes,
    required this.validLetters,
  });

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {

  final FocusNode _focus = FocusNode();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.focusNodes.add(_focus);

    controller.addListener(() {
      final String text = controller.text.contains(widget.validLetters) ? controller.text.toUpperCase() : '';
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
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.grey[850],
      elevation: 2,
      child: SizedBox(
        width: 40,
        height: 50,
        child: Center(
          child: TextField(
            focusNode: _focus,
            controller: controller,
            enabled: true,
            showCursor: false,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.only(bottom: 5, left: 5), // padding of 5 because it doesn't center for some reason
              counterText: '',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)
              )
            ), 
            style: TextStyle(
              color: Colors.grey[100],
              fontWeight: FontWeight.bold,
              letterSpacing: 4
            ),
            onChanged: (characterEntered) {
              HillManager.userAnswer[widget.textCards.indexOf(this)] = characterEntered;
            },
          )
        )
      )
    );

    widget.textCards.add(this);

    return card;
  }
}