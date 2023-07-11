import 'package:flutter/material.dart';

class AristocratEncode extends StatelessWidget {
  const AristocratEncode({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Enter a plaintext",
            style: TextStyle(
              color: Colors.grey[100],
              fontFamily: "Ysabeau",
              fontSize: 17
            )
          ),
        ),
        const SizedBox(height: 20),
        const TextField(

        )
      ],
    );
  }
}