import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enigma/services/ciphers/pollux_manager.dart';

class MorseCardManager extends StatelessWidget {
  final int marginTotal;
  final String ciphertext;
  final bool isMorbit;
  const MorseCardManager({super.key, required this.marginTotal, required this.ciphertext, required this.isMorbit});

  static Map textControllers = {};
  static Map textCards = {};
  static List focusNodes = [];
  static FocusedNumber focusedNumber = FocusedNumber(number: '');

  @override
  Widget build(BuildContext context) {
    focusedNumber.number = '';
    RegExp validLetters = RegExp(r'^[.-x]+$');
    List numbers = PolluxManager.numbers;
    addControllers(validLetters, numbers);

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
                width: isMorbit ? 40: 25,
                height: 30,
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
                focusedNumber: focusedNumber, 
                textControllers: textControllers, 
                textCards: textCards, 
                focusNodes: focusNodes, 
                validLetters: validLetters,
                isMorbit: isMorbit,
              )
            )
          ],
        )).toList()
      ),
    );
  }

  void addControllers(RegExp validLetters, List numbers) {
    for (String number in numbers) {
      TextEditingController controller = TextEditingController();

      controller.addListener(() {
        final String text = isMorbit ? controller.text : convertText(controller.text);
        controller.value = controller.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });

      textControllers[number] = controller;
    }
  }

  static String convertText(String text) {
    if (text == '.') return '.';    
    if (text == '-') return '-';
    if (text == 'x') return 'x';
    return '';
  }
}

class TextCard extends StatefulWidget {
  final String character;
  final FocusedNumber focusedNumber;
  final Map textControllers;
  final Map textCards;
  final List focusNodes;
  final RegExp validLetters;
  final bool isMorbit;

  const TextCard({super.key, 
    required this.character, 
    required this.focusedNumber, 
    required this.textControllers, 
    required this.textCards, 
    required this.focusNodes,
    required this.validLetters,
    required this.isMorbit
  });

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {

  String? prevCharacter;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    prevCharacter = '';
    widget.focusNodes.add(_focus);
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    widget.focusNodes.remove(_focus);
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (widget.focusedNumber.number.contains(widget.validLetters)) {
      for (_TextCardState textCard in widget.textCards[widget.focusedNumber.number]) {
        textCard.callback();
      }
    }
    for (_TextCardState textCard in widget.textCards[widget.character]) {
      textCard.callback();
    }
  }

  void callback() {
  if (!mounted) return;
    setState(() {
      widget.focusedNumber.number = widget.character;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.grey[850],
      elevation: 2,
      shape: widget.character == widget.focusedNumber.number ? LinearBorder.bottom(side: const BorderSide(color: Colors.blue)) : null,
      child: SizedBox(
        width: widget.isMorbit ? 40: 25,
        height: 30,
        child: Center(
          child: TextField(
            inputFormatters: widget.isMorbit ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[.xX-]")),
            ] : null,
            focusNode: _focus,
            controller: widget.textControllers.containsKey(widget.character) ? widget.textControllers[widget.character] : null,
            enabled: true,
            showCursor: false,
            textAlign: TextAlign.center,
            maxLength: widget.isMorbit ? 2: 1,
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
              letterSpacing: 4
            ),
            onChanged: (characterEntered) {
              for (_TextCardState textCard in widget.textCards[widget.character]) {
                textCard.prevCharacter = characterEntered;
              }
            },
            onTap: _onFocusChange,
          )
        )
      )
    );

    if (widget.textCards.containsKey(widget.character)) {
      widget.textCards[widget.character].add(this);
    }
    else {
      widget.textCards[widget.character] = [this,];
    }

    return card;
  }
}

// Wrapper to pass focusedNumber by reference
class FocusedNumber {
  String number;
  FocusedNumber({required this.number});
}