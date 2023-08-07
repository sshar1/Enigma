import 'package:enigma/pages/solver_page.dart';
import 'package:flutter/material.dart';
import 'package:enigma/pages/cipher_page.dart';
import 'package:enigma/pages/home.dart';
import 'package:enigma/pages/loading.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/' : (context) => const Loading(),
    '/home' : (context) => const Home(),
    '/cipherpage' : (context) => const CipherPage(),
    '/solver' : (context) => const SolverPage(),
  }
));