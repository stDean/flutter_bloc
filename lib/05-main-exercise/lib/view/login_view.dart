import 'package:bloc_state_mgt/05-main-exercise/bloc/app_event.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/extensions/if_debugging.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'test@test.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'foobar'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here.',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'enter your password here..',
              ),
              obscureText: true,
              obscuringCharacter: '#',
              keyboardAppearance: Brightness.dark,
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;

                context.read<AppBloc>().add(
                      AppEventLogIn(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Log In'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(const AppEventGoToRegistration());
              },
              child: const Text('Not registered yet? Register now.'),
            ),
          ],
        ),
      ),
    );
  }
}
