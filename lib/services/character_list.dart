import 'package:flutter/material.dart';

class CharacterList extends StatefulWidget {

  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: getLetters().map((letter) => Card(
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
          )).toList()
        )
      ]
    );
  }

  List getLetters() {
    List result = [];
    for(int i = 65; i <= 90; i++){
      result.add(String.fromCharCode(i));
    }
    return result;
  }
}