import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../cipher_manager.dart';

class PatristocratManager implements CipherManager {
  static const List letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  static final Map _key = {}; // Key: plaintext, Value: ciphertext
  static Map userKey = {}; // Key: plaintext, Value: list of ciphertexts

  static String _plaintext = "";
  static String _convertedPlaintext = "";
  static String ciphertext = "";
  static String _title = "";
  static Map frequencies = {}; // Key: ciphertext letter, Value: its frequency in the plaintext

  static String _keyword = "";
  static bool isK1 = true;

  static Future<void> next() async {
    _random(0, 10) < 8 ? isK1 = true : isK1 = false; // 80% chance for being k1
    _resetUserKey();
    await _randomizePlaintext();

    if (isK1) {
      await _randomizeKeyword();
      _randomizeK1Key(letters, getUniqueLetters(_keyword));
      while(_keyHasMatches(_key)) {
        _randomizeK1Key(letters, getUniqueLetters(_keyword));
      }
      _title += ' It is encoded with a K1 alphabet.';
    } else {
       _randomizeKey();
    }

    _updateCiphertext();
    _updateFrequencies();
  }

  static void _resetUserKey() {
    for (String str in letters) {
      userKey[str] = [];
    }
  }

  static Future<void> _randomizeKeyword() async {
    final String response = await rootBundle.loadString('lib/json/keywords.json');
    final keywords = await json.decode(response);

    _keyword = keywords[_random(0, keywords.length)].toUpperCase();
  }

  static Future<Map> _getRandomPatristocrat() async {
    final String response = await rootBundle.loadString('lib/json/patristocrat.json');
    final patristocrats = await json.decode(response);
    
    return patristocrats[_random(0, patristocrats.length)];
  }

  static Future<void> _randomizePlaintext() async {
    Map patristocrat = await _getRandomPatristocrat();
    _plaintext = patristocrat['plaintext'];
    _convertedPlaintext = convertText(_plaintext);
    _title = patristocrat['title'];
    print(_plaintext);
    print(_title);
  }

  static void _randomizeKey() {
    List temp = List.from(letters);
    for(String letter in letters) {
      String val = temp.removeAt(_random(0, temp.length));
      _key[letter] = val;

      if (_key[letter] == letter) {
        _key[letter] = temp.removeAt(_random(0, temp.length));
        temp.add(val);
      }
    }
  }

  static void _randomizeK1Key(List letters, List keyword) {
    List temp = List.from(letters);
    
    int offset = _random(0, 26);
    for (String letter in keyword) {
      _key[letter] = letters[offset % 26];
      temp.remove(letter);
      offset++;
    }
    
    for(String letter in temp) {
      _key[letter] = letters[offset % 26];
      offset++;
    }
  }

  static void _updateCiphertext() {
    ciphertext = "";
    for (String letter in _convertedPlaintext.split('')) {
      if (!_key.containsKey(letter)) {
        ciphertext += letter;
      }
      else {
        ciphertext += _key[letter];
      }
    }
  }

  static void _updateFrequencies() {
    frequencies = {};
    for (String char in ciphertext.split('')) {
      if (!char.contains(RegExp(r'^[a-zA-Z]+$'))) continue;
      if (!frequencies.containsKey(char)) {
        frequencies[char] = 1;
        continue;
      }
      frequencies[char]++;
    }

    for (String letter in letters) {
      if (!frequencies.containsKey(letter)) {
        frequencies[letter] = 0;
      }
    }
  }
 
  // Check if userkey is equal to the actual key
  static bool keysMatch() {
    for (String letter in _key.keys) {
      if (frequencies[_key[letter]] == 0) continue;

      if (userKey[letter].length == 0 || _key[letter] != userKey[letter][0]) {
        return false;
      }
    }
    return true;
  }

  // Check if any plaintext corresponds to the same ciphertext
  static bool _keyHasMatches(Map key) {
    for (String plain in key.keys) {
      if (key[plain] == plain) {
        return true;
      }
    }
    return false;
  }

  static String convertText(String plaintext) {
    String convertedPlaintext = "";
    plaintext = plaintext.toUpperCase();
    int count = 0;

    for (String s in plaintext.split('')) {
      if (s.contains(RegExp(r'^[a-zA-Z]+$'))) {
        if (count % 5 == 0 && count != 0) {
          convertedPlaintext += ' ';
        }
        convertedPlaintext += s;
        count++;
      }
    }
    return convertedPlaintext;
  }

  static List getUniqueLetters(String text) {
    List uniqueLetters = [];
    
    for(String s in text.split('')) {
      if (!uniqueLetters.contains(s)) {
        uniqueLetters.add(s);
      }
    }
    
    return uniqueLetters;
  }

  static String getTitle() {
    return _title;
  }

  static String getPlaintext() {
    return _plaintext;
  }

  // Converts plaintext to ciphertext
  static String plainToCipher(String plain) {
    return _key[plain];
  }

  // Converts ciphertext to plaintext
  static String cipherToPlain(String cipher) {
    return _key.keys.firstWhere((k) => _key[k] == cipher, orElse: () => '');
  }

  // From min to max-1
  static int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}