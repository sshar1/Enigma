import 'dart:math';

class AristocratManager {
  static final List letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  static Map key = {}; // Key: plaintext, Value: ciphertext

  static String plaintext = "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin, but by the content of their character.".toUpperCase();
  static String ciphertext = "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin, but by the content of their character.".toUpperCase();
  static Map frequencies = {}; // Key: ciphertext letter, Value: Its frequency in the plaintext

  static Future<void> nextAristocrat() async {
    _randomizePlaintext();
    _randomizeKey();
    _updateCiphertext();
    _updateFrequencies();
  }

  static void _randomizePlaintext() {
    plaintext = "I have a dream that my four little children will one day live in a nation where they will not be judged by the color of their skin, but by the content of their character.".toUpperCase();
  }

  static void _randomizeKey() {
    List temp = List.from(letters);
    for(String letter in letters) {
      String val = temp.removeAt(_random(0, temp.length));
      key[letter] = val;
      
      if (key[letter] == letter) {
        key[letter] = temp.removeAt(_random(0, temp.length));
        temp.add(val);
      }
    }
  }

  static void _updateCiphertext() {
    ciphertext = "";
    for (String letter in plaintext.split('')) {
      if (!key.containsKey(letter)) {
        ciphertext += letter;
      }
      else {
        ciphertext += key[letter];
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

  // From min to max-1
  static int _random(int min, int max) {
    return min + Random().nextInt(max - min);
  }
}