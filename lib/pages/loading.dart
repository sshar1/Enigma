import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  // This literally does nothing but wait 8 seconds so you can see a cool loading screen. Thats it
  Future<void> loadDummy() async {
    await Future.delayed(const Duration(seconds: 8));
    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  void initState() {
    super.initState();
    loadDummy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitSpinningLines(
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 10),
            Text(
              'ENIGMA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 70,
                fontFamily: 'Ysabeau'
              )
            )
          ]
        )
      )
    );
  }
}
