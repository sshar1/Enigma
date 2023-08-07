import 'package:flutter/material.dart';

class CipherInfo {
  String name; // Name of cipher
  IconData icon; // Icon of cipher
  String description; // Description of cipher
  Color color; // Color for card
  Map pages; // Encode and decode pages
  Function checkWin;
  Function getPlaintext;
  Function nextCipher;
  Function encode;
  Function getEncodeCiphertext;
  Function encodeReady;
  Function clearEncodingVariables;

  CipherInfo({
    required this.name, 
    required this.icon, 
    required this.description, 
    required this.color, 
    required this.pages, 
    required this.checkWin, 
    required this.getPlaintext,
    required this.nextCipher,
    required this.encode,
    required this.getEncodeCiphertext,
    required this.encodeReady,
    required this.clearEncodingVariables,
  });
}