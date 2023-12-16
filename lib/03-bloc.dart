import 'package:flutter/material.dart';

class MySecondBlocWidget extends StatelessWidget {
  const MySecondBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Bloc Exercise'),
      ),
      body: const Center(
        child: Text('Hello America'),
      ),
    );
  }
}
