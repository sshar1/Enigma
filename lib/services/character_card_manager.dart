import 'package:flutter/material.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';

class CharacterCardManager extends StatelessWidget {
  final int marginTotal;
  const CharacterCardManager({super.key, required this.marginTotal});

  static Map textControllers = {};
  static Map textCards = {};
  static FocusedLetter focusedLetter = FocusedLetter(letter: '');

  static const double cardWidth = 25;

  @override
  Widget build(BuildContext context) {
    focusedLetter.letter = '';
    addControllers();

    return Column(
      children: getRows(context).map((line) => Row(
        children: line.split('').map<Widget>((character) => Column(
          children: [
            Card(
              margin: const EdgeInsets.only(),
              color: character.contains(RegExp(r'^[a-zA-Z]+$')) ? Colors.grey[850] : Colors.grey[900],
              elevation: character.contains(RegExp(r'^[a-zA-Z]+$')) ? 2 : 0,
              child: SizedBox(
                width: cardWidth,
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
            TextCard(character: character, focusedLetter: focusedLetter, textControllers: textControllers, textCards: textCards)
          ],
        )).toList()
      )).toList()
    );
  }

  static void addControllers() {
    for (int i = 65; i <= 90; ++i) {
      TextEditingController controller = TextEditingController();

      controller.addListener(() {
        final String text = controller.text.contains(RegExp(r'^[a-zA-Z]+$')) ? controller.text.toUpperCase() : '';
        controller.value = controller.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });

      textControllers[String.fromCharCode(i)] = controller;
    }
  }

  List getRows(BuildContext context) {
    String quote = AristocratManager.ciphertext;
    int width = MediaQuery.of(context).size.width.toInt();
    int marginTotal = 100;
  
    int totalPixels = width - marginTotal;
    int cardsPerLine = (totalPixels ~/ cardWidth);
  
    List quoteList = quote.split(' ');
  
    List rows = <String>[''];
    int current = 0;
    for (String word in quoteList) {
      if (word.length > cardsPerLine) {
        continue;
      }
      
      if (word.length + rows[current].length > cardsPerLine) {
        ++current;
        rows.add('$word ');
        continue;
      } else {
        rows[current] += word;
      }
      
      if (rows[current].length < cardsPerLine) {
        rows[current] += ' ';
      }
    }
  
    return rows;
  }
}

class TextCard extends StatefulWidget {
  final String character;
  final FocusedLetter focusedLetter;
  final Map textControllers;
  final Map textCards;

  const TextCard({super.key, required this.character, required this.focusedLetter, required this.textControllers, required this.textCards});

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {

  void callback() {
  if (!mounted) return;
    setState(() {
      widget.focusedLetter.letter = widget.character;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: widget.character.contains(RegExp(r'^[a-zA-Z]+$')) ? Colors.grey[850] : Colors.grey[900],
      elevation: widget.character.contains(RegExp(r'^[a-zA-Z]+$')) ? 2 : 0,
      shape: widget.character == widget.focusedLetter.letter ? LinearBorder.bottom(side: const BorderSide(color: Colors.blue)) : null,
      child: SizedBox(
        width: 25,
        height: 30,
        child: Center(
          child: TextField(
            controller: widget.textControllers.containsKey(widget.character) ? widget.textControllers[widget.character] : null,
            enabled: widget.character.contains(RegExp(r'^[a-zA-Z]+$')) ? true : false,
            showCursor: false,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              contentPadding: EdgeInsets.only(bottom: 15, left: 2), // padding of 2 because it doesn't center for some reason
              counterText: ''
            ), 
            style: TextStyle(
              color: Colors.grey[100],
              fontWeight: FontWeight.bold,
            ),
            onChanged: (characterEntered) {
              AristocratManager.userKey[widget.character] = characterEntered;
            },
            onTap: () {
              if (widget.focusedLetter.letter.contains(RegExp(r'^[a-zA-Z]+$'))) {
                for (_TextCardState textCard in widget.textCards[widget.focusedLetter.letter]) {
                  textCard.callback();
                }
              }
              for (_TextCardState textCard in widget.textCards[widget.character]) {
                textCard.callback();
              }
            }
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

// Wrapper to pass focusedletter 
class FocusedLetter {
  String letter;
  FocusedLetter({required this.letter});
}