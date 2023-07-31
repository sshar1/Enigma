import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../cipher_manager.dart';

class MorbitManager implements CipherManager {
  static const Map morse = { 
    'A' : '.-', 
    'B' : '-...',
    'C' : '-.-.', 
    'D' : '-..', 
    'E' : '.',
    'F' : '..-.', 
    'G' : '--.', 
    'H' : '....',
    'I' : '..', 
    'J' : '.---', 
    'K' : '-.-',
    'L' :  '.-..', 
    'M' : '--', 
    'N' :  '-.',
    'O' : '---', 
    'P' : '.--.', 
    'Q' : '--.-',
    'R' : '.-.', 
    'S' : '...', 
    'T' : '-',
    'U' : '..-', 
    'V' : '...-', 
    'W' : '.--',
    'X' : '-..-', 
    'Y' : '-.--', 
    'Z' : '--..',
    '\'': '',
    ' ' : ''
  };
  static const List morseChars = [
    '..', 
    '.-',
    '.x',
    '-.', 
    '--',
    '-x',
    'x.',
    'x-',
    'xx'
  ];
  static const List numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static final Map _key = {}; // Key: plaintext morse, Value: ciphertext number

  static String _plaintext = ""; // String of plain english
  static String _convertedPlaintext = ""; // String of morse code
  static String ciphertext = ""; // String of numbers
  static String _title = "";
  static String userAnswer = "";

  static List usedNums = [];
  static final Map _givens = {};

  // ENCODING VARIABLES
  static String _encodePlaintext = "";
  static String _encodeCiphertext = "";

  static Future<void> next() async {
    usedNums.clear();
    await _randomizePlaintext();
    _randomizeKey();
    _updateCiphertext();
    _randomizeGivens();
    _title += "You are given that ";
    for (String num in _givens.keys) {
      _title += '$num = ${_givens[num]}  ';
    }
  }

  static Future<Map> _getRandomMorbit() async {
    final String response = await rootBundle.loadString('lib/json/morbit.json');
    final morbits = await json.decode(response);
    
    return morbits[_random(0, morbits.length)];
  }

  static Future<void> _randomizePlaintext() async {
    Map morbit = await _getRandomMorbit();
    _plaintext = morbit['plaintext'];
    _convertedPlaintext = convertText(_plaintext);
    _title = morbit['title'];
    print(_plaintext);
    print(_title);
  }

  static void _randomizeKey() {
    _key.clear();

    List temp = List.from(numbers);
    for (String morseChar in morseChars) {
      _key[morseChar] = temp.removeAt(_random(0, temp.length));
    }
  }

  static void _updateCiphertext() {
    ciphertext = "";
    for (int i = 0; i < _convertedPlaintext.length; i += 2) {
      String num = _key[_convertedPlaintext.substring(i, i + 2)];
      ciphertext += num;
      if (!usedNums.contains(num)) {
        usedNums.add(num);
      }
    }
  }

  static void _randomizeGivens() {
    _givens.clear();
    int givenLength = (usedNums.length / 2).round() - 1;

    int index = 0;
    for (String morse in _key.keys) {
      _givens[_key[morse]] = morse;
      index++;
      if (index >= givenLength) {
        return;
      }
    }
  }

  static String convertText(String plaintext) {
    String convertedPlaintext = "";
    plaintext = plaintext.toUpperCase();

    for (String s in plaintext.toUpperCase().split('')) {
      if (morse.containsKey(s)) {
        convertedPlaintext += '${morse[s]}x';
      }
    }
    convertedPlaintext = convertedPlaintext.isEmpty ? '' : convertedPlaintext.substring(0, convertedPlaintext.length-1);
    
    if (convertedPlaintext.length % 2 == 1) {
      convertedPlaintext += 'x'; 
    }

    return convertedPlaintext;
  }

  static bool checkWin() {
    String allCapPlaintext = "";
    
    for (String char in _plaintext.toUpperCase().split('')) {
      if (char == ' ' || char == '\'' || char.contains(RegExp(r'^[A-Z]+$'))) {
        allCapPlaintext += char.toUpperCase();
      }
    }
    
    return userAnswer == allCapPlaintext;
  }

  // ENCODING FUNCTIONS
  static void clearEncodingVariables() {
    _encodePlaintext = "";
    _encodeCiphertext = "";
  }

  static void encode() async {
    _randomizeKey();
    String morsePlaintext = convertText(_encodePlaintext);

    for (int i = 0; i < morsePlaintext.length; i += 2) {
      String num = _key[morsePlaintext.substring(i, i + 2)];
      _encodeCiphertext += num;
    }
  }

  static bool encodeReady() {
    return true;
  }

  static setEncodePlaintext(String text) => _encodePlaintext = convertPlaintext(text);

  static convertPlaintext(String text) {
    String result = "";
    for (String char in text.trim().toUpperCase().split('')) {
      if (char.contains(RegExp("[A-Z' ]"))) {
        result += char;
      }
    }
    return result;
  }

  static String getTitle() {
    return _title;
  }

  static String getPlaintext() {
    return _plaintext;
  }

  static String getEncodingCiphertext() {
    return _encodeCiphertext;
  }

  // From min to max-1
  static int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}