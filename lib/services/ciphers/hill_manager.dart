import 'dart:math';

import '../cipher_manager.dart';

class HillManager implements CipherManager {
  static const List letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

  static String key = "";
  static List keyMatrix = [];

  static String _plaintext = "";
  static String _convertedPlaintext = "";
  static List _plaintextMatrix = [];
  static String ciphertext = "";
  static String _title = "";

  static Future<void> next() async {
    await _randomizePlaintext();
    await _randomizeKey();
    _updatePlaintextMatrix();
    _updateKeyMatrix();
    _title += " The key used to encode it is $key = ${keyMatrix.toString()}";
    _updateCiphertext();
  }

  static Future<void> _randomizeKey() async {
    // final String response = await rootBundle.loadString('lib/json/hill_keys.json');
    // final keys = await json.decode(response);

    // key = keys[_random(0, keys.length)].toUpperCase();
    key = "wiki".toUpperCase();
  }

  static void _updateKeyMatrix() {
    List wordLetters = key.split('');
    keyMatrix = [
      [letters.indexOf(wordLetters[0]), letters.indexOf(wordLetters[1])],
      [letters.indexOf(wordLetters[2]), letters.indexOf(wordLetters[3])]
    ];
  }

  static Future<Map> _getRandomHill() async {
    // final String response = await rootBundle.loadString('lib/json/hill.json');
    // final hills = await json.decode(response);
    
    // return hills[_random(0, hills.length)];
    return {
        "plaintext" : "science olympiad",
        "title" : "[150 points] Decode this quote by Alexander Pope which has been encoded using a Hill Cipher."
    };
  }

  static Future<void> _randomizePlaintext() async {
    Map hill = await _getRandomHill();
    _plaintext = hill['plaintext'];
    _convertedPlaintext = convertText(_plaintext);
    _title = hill['title'];
    print(_plaintext);
    print(_title);
  }

  static String convertText(String text) {
    String converted = "";
    for (String char in _plaintext.toUpperCase().split('')) {
      if (char.contains(RegExp(r'^[A-Z]+$'))) {
        converted += char;
      }
    }
    if (converted.length % 2 == 0) {
      return converted;
    }
    return '${converted}Z';
  }

  static void _updatePlaintextMatrix() {
    _plaintextMatrix = [];
    for (String s in _convertedPlaintext.split('')) {
      _plaintextMatrix.add(letters.indexOf(s));
    }
  }

  static void _updateCiphertext() {
    ciphertext = "";
    for (int i = 0; i < _plaintextMatrix.length; i+=2) {
      List tempMatrix = multiply(keyMatrix, [_plaintextMatrix[i], _plaintextMatrix[i+1]]);
      
      ciphertext += letters[tempMatrix[0] % 26];
      ciphertext += letters[tempMatrix[1] % 26];
    }
  }

  // Multiply m1, the key, by m2, two letter matrix of plaintext
  static List multiply(List m1, List m2) {
    assert (m1.length == 2 && m2.length == 2 && m1[0].length == 2 && m1[1].length == 2);
    return [
      m1[0][0] * m2[0] + m1[0][1] * m2[1], 
      m1[1][0] * m2[0] + m1[1][1] * m2[1]
    ];
  }

  static bool keysMatch() {
    return true;
  }

  static String getTitle() {
    return _title;
  }

  static String getPlaintext() {
    return _plaintext;
  }

  // From min to max-1
  static int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}