import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../services/ciphers/aristocrat_manager.dart';
import 'ciphers/xenocrypt_manager.dart';
import 'language.dart';

class EncodeScreenManager extends StatelessWidget {
  final Function setEncodePlaintext;
  final Function getUsingCustomKey;
  final Function setUsingCustomKey;
  final Function getEncodeK1;
  final Function setEncodeK1;
  final Function appendToKey;
  final Language language;

  const EncodeScreenManager({
    super.key, 
    required this.setEncodePlaintext,
    required this.getUsingCustomKey,
    required this.setUsingCustomKey,
    required this.getEncodeK1,
    required this.setEncodeK1,
    required this.appendToKey,
    required this.language,
  });

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
    RegExp validLetters = language == Language.english ? RegExp("[a-zA-Z' ,.?!:;]") : RegExp("[a-zA-ZÑñ' ,.?!:;]");
    final TextEditingController controller = TextEditingController();

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
            FilteringTextInputFormatter.allow(validLetters),
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
          onChanged: (value) => setEncodePlaintext(controller.text)
        ),
        const SizedBox(height: 20),
        KeyList(
          focusNodes: focusNodes,
          getUsingCustomKey: getUsingCustomKey,
          setUsingCustomKey: setUsingCustomKey,
          getEncodeK1: getEncodeK1,
          setEncodeK1: setEncodeK1,
          appendToKey: appendToKey,
          language: language,
        )
      ],
    );
  }
}

class KeyList extends StatefulWidget {
  final List focusNodes;
  final Language language;
  final Function getUsingCustomKey;
  final Function setUsingCustomKey;
  final Function getEncodeK1;
  final Function setEncodeK1;
  final Function appendToKey;

  const KeyList({
    super.key, 
    required this.focusNodes,
    required this.getUsingCustomKey,
    required this.setUsingCustomKey,
    required this.getEncodeK1,
    required this.setEncodeK1,
    required this.appendToKey,
    required this.language,
  });

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
          value: widget.getUsingCustomKey(),
          onChanged: (bool value) {
            setState(() {
              widget.setUsingCustomKey(value);
            });
          },
          activeColor: Colors.grey[100],
          activeTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.grey[600],
          inactiveTrackColor: Colors.grey[800],
        ),
        if (!widget.getUsingCustomKey()) SwitchListTile(
          title: Text(
            "K1 encrypt",
            style: TextStyle(
              fontFamily: 'Ysabeau',
              color: Colors.grey[100],
              fontSize: 20
            )
          ),
          value: widget.getEncodeK1(), 
          onChanged: (bool value) {
            setState(() {
              widget.setEncodeK1(value);
            });
          },
          activeColor: Colors.grey[100],
          activeTrackColor: Colors.grey[400],
          inactiveThumbColor: Colors.grey[600],
          inactiveTrackColor: Colors.grey[800],
        ),
        const SizedBox(height: 20),
        if (widget.getUsingCustomKey()) LetterList(focusNodes: widget.focusNodes, appendToKey: widget.appendToKey, language: widget.language)
      ],
    );
  }
}

class LetterList extends StatelessWidget {
  final List focusNodes;
  final Function appendToKey;
  final Language language;
  const LetterList({super.key, required this.focusNodes, required this.appendToKey, required this.language});

  @override
  Widget build(BuildContext context) {

    List letters = (language == Language.english) ? AristocratManager.letters : XenocryptManager.letters;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: letters.map((letter) => Column(
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
          LetterTextField(plaintext: letter, focusNodes: focusNodes, appendToKey: appendToKey, language: language),
          const SizedBox(width: 10,)
        ],
      )).toList()
    );
  }
}

class LetterTextField extends StatefulWidget {
  final String plaintext;
  final List focusNodes;
  final Language language;
  final Function appendToKey;
  const LetterTextField({super.key, required this.plaintext, required this.focusNodes, required this.appendToKey, required this.language});

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
      RegExp validLetters = widget.language == Language.english ? RegExp("[a-zA-Z]") : RegExp("[a-zA-ZÑñ1]");
      final String text = controller.text.contains(validLetters) ? controller.text.toUpperCase() : '';
      controller.value = controller.value.copyWith(
        text: text == '1' && widget.language == Language.spanish ? 'Ñ' : text,
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
            onChanged: (value) => widget.appendToKey(widget.plaintext, value)//AristocratManager.encodeKey[widget.plaintext] = value,
          )
        )
      )
    );

    return card;
  }
}