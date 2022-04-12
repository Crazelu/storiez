import 'package:flutter/material.dart';
import 'package:project/presentation/shared/shared.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Demo"),
          Space(),
          Text("Text"),
        ],
      ),
    );
  }
}
