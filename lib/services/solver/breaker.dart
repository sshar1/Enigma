import 'dart:convert';

import 'package:flutter/services.dart';

class Breaker {
  static const List letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  static dynamic data;
  static dynamic quadgrams;

  // Private constructor
  Breaker._init();

  // Public factory
  static Future<Breaker> init() async {
    var breaker = Breaker._init();

    final String response = await rootBundle.loadString('lib/json/quadgram/EN.json');
    data = await json.decode(response);

    quadgrams = data['quadgrams'];

    return breaker;
  }

  static List getCipherBin(String ciphertext) {
    List result = [];
  
    for (String char in ciphertext.toUpperCase().split('')) {
      int val = letters.indexOf(char);
      if (val != -1) {
        result.add(val);
      }
    }

    return result;
  }

  static List getCharPositions(List cipherBin) {
    List charPositions = [];
    for (int idx = 0; idx < letters.length; ++idx) {
      List temp = [];
      for (int i = 0; i < cipherBin.length; ++i) {
        if (cipherBin[i] == idx) {
          temp.add(i);
        }
      }
      charPositions.add(temp);
    }

    return charPositions;
  }

  String decode(String key, String ciphertext) {
    String result = "";
    for (String char in ciphertext.toUpperCase().split('')) {
      if (letters.contains(char)) {
        result += letters[key.toUpperCase().indexOf(char)];
      } else {
        result += char;
      }
    }
    return result;
  }

  List _hillClimbing(List key, List cipherBin, List charPositions) {
    List plaintext = [];

    for (var idx in cipherBin) {
      plaintext.add(idx);
    }

    List quadgram = quadgrams;
    int keyLen = letters.length;
    int nbrKeys = 0;
    num maxFitness = 0;
    bool betterKey = true;

    while (betterKey) {
      betterKey = false;
      for (int idx1 = 0; idx1 < keyLen - 1; ++idx1) {
        for (int idx2 = idx1 + 1; idx2 < keyLen; ++idx2) {
          int ch1 = key[idx1];
          int ch2 = key[idx2];
          for (int idx in charPositions[ch1]) {
            plaintext[idx] = idx2;
          }
          for (int idx in charPositions[ch2]) {
            plaintext[idx] = idx1;
          }
          nbrKeys++;
          num tmpFitness = 0;
          int quadIdx = (plaintext[0] << 10) + (plaintext[1] << 5) + plaintext[2];
          for (int char in plaintext.sublist(3)) {
            quadIdx = ((quadIdx & 0x7FFF) << 5) + char;
            tmpFitness += quadgram[quadIdx];
          }
          if (tmpFitness > maxFitness) {
            maxFitness = tmpFitness;
            betterKey = true;
            key[idx1] = ch2;
            key[idx2] = ch1;
          } else {
            for (int idx in charPositions[ch1]) {
              plaintext[idx] = idx1;
            }
            for (int idx in charPositions[ch2]) {
              plaintext[idx] = idx2;
            }
          }
        }
      }
    }
    return [maxFitness, nbrKeys];
  }

  Map breakCipher(String ciphertext){
    int maxRounds = 1000;
    int consolidate = 3;

    num startTime = DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerSecond;
    int nbrKeys = 0;
    List cipherBin = getCipherBin(ciphertext);

    List charPositions = getCharPositions(cipherBin);

    int keyLen = letters.length;
    num localMaximum = 0;
    int localMaximumHit = 1;
    List key = [];
    for (int i = 0; i < keyLen; ++i) {
      key.add(i);
    }
    List bestKey = List.from(key);
    for (int roundCntr = 0; roundCntr < maxRounds; ++roundCntr) {
      key.shuffle();
      List hillResults = _hillClimbing(key, cipherBin, charPositions);
      num fitness = hillResults[0];
      int tmpNbrKeys = hillResults[1];
      nbrKeys += tmpNbrKeys;
      if (fitness > localMaximum) {
        localMaximum = fitness;
        localMaximumHit = 1;
        bestKey = List.from(key);
      } else if (fitness == localMaximum) {
        localMaximumHit++;
        if (localMaximumHit == consolidate) {
          break;
        }
      }            
    }

    String keyStr = "";
    for (int x in bestKey) {
      keyStr += letters[x];
    }
    num seconds = (DateTime.now().millisecondsSinceEpoch / Duration.millisecondsPerSecond) - startTime;
    return {
        'ciphertext' : ciphertext,
        'plaintext' : decode(keyStr, ciphertext),
        'key' : keyStr,
        'fitness' : localMaximum / (cipherBin.length - 3) / 10,
        'nbr_keys' : nbrKeys,
        'keys_per_second' : (nbrKeys / seconds).toStringAsFixed(3),
        'seconds' : seconds.toStringAsFixed(3),
    };
  }
}