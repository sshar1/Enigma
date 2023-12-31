import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../cipher_manager.dart';

class PolluxManager implements CipherManager {
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
  static const List morseChars = ['.', '-', 'x'];
  static const List numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  static final Map _key = {}; // Key: plaintext morse, Value: list of ciphertext numbers

  static String _plaintext = ""; // String of plain english
  static String _convertedPlaintext = ""; // String of morse code
  static String ciphertext = ""; // String of numbers
  static String _title = "";
  static String userAnswer = "";

  static int numLength = 0;
  static final Map _givens = {};

  // ENCODING VARIABLES
  static String _encodePlaintext = "";
  static String _encodeCiphertext = "";

  static Future<void> next() async {
    await _randomizePlaintext();
    _randomizeKey();
    _randomizeGivens();
    _title += "You are given that ";
    for (String num in _givens.keys) {
      _title += '$num = ${_givens[num]}  ';
    }
    _updateCiphertext();
  }

  static Future<Map> _getRandomPollux() async {
    final String response = await rootBundle.loadString('lib/json/pollux.json');
    final polluxes = await json.decode(response);
    
    return polluxes[_random(0, polluxes.length)];
  }

  static Future<void> _randomizePlaintext() async {
    Map pollux = await _getRandomPollux();
    _plaintext = pollux['plaintext'];
    _convertedPlaintext = convertText(_plaintext);
    _title = pollux['title'];
  }

  static void _randomizeKey() {
    _key.clear();

    List temp = List.from(numbers);
    numLength = _random(4, 10);

    for (int i = 0; i < numLength; ++i) {
      if (_key.containsKey(morseChars[i % 3])) {
        _key[morseChars[i % 3]].add(temp.removeAt(_random(0, temp.length)));
      }
      else {
        _key[morseChars[i % 3]] = [temp.removeAt(_random(0, temp.length)),];
      }
    }
  }

  static void _updateCiphertext() {
    ciphertext = "";
    for (String char in _convertedPlaintext.split('')) {
      ciphertext += _key[char][_random(0, _key[char].length)]; 
    }
  }

  static void _randomizeGivens() {
    _givens.clear();
    int givenLength = (numLength / 2).round() - 1;

    for (int i = 0; i < givenLength; ++i) {
      _givens[_key[morseChars[i % 3]][(i / 3).truncate()]] = morseChars[i % 3];
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
    return convertedPlaintext.isEmpty ? '' : convertedPlaintext.substring(0, convertedPlaintext.length-1);
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

    for (String char in morsePlaintext.split('')) {
      _encodeCiphertext += _key[char][_random(0, _key[char].length)]; 
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