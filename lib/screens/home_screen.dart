import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.house_rounded,
              color: Colors.blue.shade300,
              size: 40,
            ),
            const Text(
              "집사",
            ),
          ],
        ),
      ),
    );
  }
}
