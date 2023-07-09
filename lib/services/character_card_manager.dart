import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';

import 'character_list.dart';

class CharacterCardManager extends StatelessWidget {
  final int marginTotal;
  const CharacterCardManager({super.key, required this.marginTotal});

  static Map textControllers = {};
  static Map textCards = {};
  static List focusNodes = [];
  static FocusedLetter focusedLetter = FocusedLetter(letter: '');

  static const double cardWidth = 25;

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
    focusedLetter.letter = '';
    addControllers();

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
      child: Column(
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
              FocusTraversalOrder(
                order: NumericFocusOrder(index++),
                child: TextCard(character: character, focusedLetter: focusedLetter, textControllers: textControllers, textCards: textCards, focusNodes: focusNodes,)
              )
            ],
          )).toList()
        )).toList()
      ),
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
    String quote = AristocratManager.ciphertext; // TODO add argument for getting the ciphertext, dont use aristocrat manager directly
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
  final List focusNodes;

  const TextCard({super.key, 
    required this.character, 
    required this.focusedLetter, 
    required this.textControllers, 
    required this.textCards, 
    required this.focusNodes
  });

  @override
  State<TextCard> createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {

  bool? borderRed;
  String? prevCharacter;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    borderRed = false;
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
    if (widget.focusedLetter.letter.contains(RegExp(r'^[a-zA-Z]+$'))) {
      for (_TextCardState textCard in widget.textCards[widget.focusedLetter.letter]) {
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
      widget.focusedLetter.letter = widget.character;
    });
  }

  void redBorder(bool enable) {
    if (!mounted) return;

    if (enable) {
      setState(() {
        borderRed = true;
      });
    } else {
      setState(() {
        borderRed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: widget.character.contains(RegExp(r'^[a-zA-Z]+$')) ? Colors.grey[850] : Colors.grey[900],
      elevation: widget.character.contains(RegExp(r'^[a-zA-Z]+$')) ? 2 : 0,
      shape: widget.character == widget.focusedLetter.letter ? LinearBorder.bottom(side: BorderSide(color: getBorderColor())) : null,
      child: SizedBox(
        width: 25,
        height: 30,
        child: Center(
          child: TextField(
            focusNode: _focus,
            controller: widget.textControllers.containsKey(widget.character) ? widget.textControllers[widget.character] : null,
            enabled: widget.character.contains(RegExp(r'^[a-zA-Z]+$')) ? true : false,
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
            onChanged: (characterEntered) {
              if (characterEntered == '') {
                String? temp = prevCharacter;
                AristocratManager.userKey[prevCharacter].remove(widget.character);
                CharacterList.replacementCardStates[widget.character].callback();
                for (_TextCardState textCard in widget.textCards[widget.character]) {
                  textCard.prevCharacter = characterEntered;
                  textCard.redBorder(false);
                }
                if (AristocratManager.userKey[temp].length == 0) return;
                CharacterList.replacementCardStates[AristocratManager.userKey[temp][0]].callback();
                for (_TextCardState textCard in widget.textCards[AristocratManager.userKey[temp][0]]) {
                  textCard.redBorder(false);
                }
                return;
              }

              AristocratManager.userKey[characterEntered].add(widget.character);
              CharacterList.replacementCardStates[widget.character].callback();
              for (_TextCardState textCard in widget.textCards[widget.character]) {
                textCard.prevCharacter = characterEntered;
              }

              if (AristocratManager.userKey[characterEntered].length > 1) {
                for (_TextCardState textCard in widget.textCards[widget.character]) {
                  textCard.prevCharacter = characterEntered;
                  textCard.redBorder(true);
                }
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

  Color getBorderColor() {
    if (borderRed!) return Colors.red;
    return Colors.blue;
  }
}

// Wrapper to pass focusedletter by reference
class FocusedLetter {
  String letter;
  FocusedLetter({required this.letter});
}