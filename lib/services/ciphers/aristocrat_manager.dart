import 'dart:math';

import '../cipher_manager.dart';

class AristocratManager implements CipherManager {
  static const List letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  static final Map _key = {}; // Key: plaintext, Value: ciphertext
  static Map userKey = {}; // Key: plaintext, Value: list of ciphertexts

  static String plaintext = "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin, but by the content of their character.".toUpperCase();
  static String ciphertext = "";
  static Map frequencies = {}; // Key: ciphertext letter, Value: its frequency in the plaintext

  static Future<void> next() async {
    _resetUserKey();
    _randomizePlaintext();
    _randomizeKey();
    _updateCiphertext();
    _updateFrequencies();
  }

  static void _resetUserKey() {
    for (String str in letters) {
      userKey[str] = [];
    }
  }

  static void _randomizePlaintext() {
    plaintext = "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin, but by the content of their character.".toUpperCase();
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

  static void _updateCiphertext() {
    ciphertext = "";
    for (String letter in plaintext.split('')) {
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

  static bool keysMatch() {
    for (String letter in _key.keys) {
      if (frequencies[_key[letter]] == 0) continue;

      if (userKey[letter].length == 0 || _key[letter] != userKey[letter][0]) {
        return false;
      }
    }
    return true;
  }

  // Converts plaintext to ciphertext
  static String plainToCipher(String plain) {
    return _key[plain];
  }

  // Converts ciphertext to plaintext
  static String cipherToPlain(String cipher) {
    return _key.keys.firstWhere((k) => AristocratManager._key[k] == cipher, orElse: () => '');
  }

  // From min to max-1
  static int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}