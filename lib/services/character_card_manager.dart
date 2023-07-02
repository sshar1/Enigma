import 'package:flutter/material.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';

class CharacterCardManager extends StatefulWidget {

  final int marginTotal;

  const CharacterCardManager({super.key, required this.marginTotal});

  @override
  State<CharacterCardManager> createState() => _CharacterCardManagerState(marginTotal: marginTotal);
}

class _CharacterCardManagerState extends State<CharacterCardManager> {

  static const double cardWidth = 25;
  int? marginTotal;
  
  _CharacterCardManagerState({required int marginTotal}); 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: getRows().map((line) => Row(
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
            Card(
              margin: const EdgeInsets.only(bottom: 20),
              color: character.contains(RegExp(r'^[a-zA-Z]+$')) ? Colors.grey[850] : Colors.grey[900],
              elevation: character.contains(RegExp(r'^[a-zA-Z]+$')) ? 2 : 0,
              child: SizedBox(
                width: cardWidth,
                height: 30,
                child: Center(
                  child: TextField(
                    enabled: character.contains(RegExp(r'^[a-zA-Z]+$')) ? true : false,
                    // showCursor: false,
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
                    onChanged: (txt) {
                      print(txt);
                    },
                  )
                )
              )
            ),
          ],
        )).toList()
      )).toList()
    );
  }

  List getRows() {
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