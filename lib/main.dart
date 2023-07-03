import 'package:flutter/material.dart';
import 'package:myapp/pages/cipher_page.dart';
import 'package:myapp/pages/home.dart';
import 'package:myapp/pages/loading.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/' : (context) => const Loading(),
    '/home' : (context) => const Home(),
    '/cipherpage' : (context) => const CipherPage()
  }
));