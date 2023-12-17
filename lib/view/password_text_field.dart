import 'package:bloc_state_mgt/string03.dart' show enterPasswordHere;
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController passwordController;

  const PasswordTextField({super.key, required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      obscureText: true,
      obscuringCharacter: '#',
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: enterPasswordHere,
      ),
    );
  }
}
