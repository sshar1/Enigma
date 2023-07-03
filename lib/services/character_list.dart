import 'package:flutter/material.dart';
import 'package:myapp/services/ciphers/aristocrat_manager.dart';

class CharacterList extends StatefulWidget {

  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => CharacterListState();
}

class CharacterListState extends State<CharacterList> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: AristocratManager.letters.map((letter) => Column(
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
                    AristocratManager.frequencies[letter] == 0 ? '' : AristocratManager.frequencies[letter].toString(),
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              )
          ),
          Card(
            shape: LinearBorder.top(side: BorderSide(color: Colors.grey[100]!)),
            margin: const EdgeInsets.only(),
              color: Colors.grey[850],
              elevation: 2,
              child: SizedBox(
                width: 35,
                height: 30,
                child: Center(
                  child: Text(
                    AristocratManager.userKey[letter],
                    //AristocratManager.cipherToPlain(letter),
                    style: TextStyle(
                      color: Colors.grey[100],
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              )
          ),
        ],
      )).toList()
    );
  }
}