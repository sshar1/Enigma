import 'package:flutter/material.dart';

class CipherInfo {
  String name; // Name of cipher
  String image; // Path to get image
  String description; // Description of cipher
  Color color; // Color for card
  Map pages;

  CipherInfo( {required this.name, required this.image, required this.description, required this.color, required this.pages} );
}