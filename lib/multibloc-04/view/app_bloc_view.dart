import 'package:bloc_state_mgt/multibloc-04/bloc/app_bloc.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/app_state.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/bloc_event.dart';
import 'package:bloc_state_mgt/multibloc-04/extensions/streams/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocWidget<T extends AppBloc> extends StatelessWidget {
  const AppBlocWidget({super.key});

  void startUpdating(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextImageEvent(),
    ).startWith(const LoadNextImageEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdating(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            return const Text(
              'An Error Occurred, Try again in a moment!!',
              style: TextStyle(color: Colors.red),
            );
          } else if (appState.imgData != null) {
            return Image.memory(appState.imgData!, fit: BoxFit.fitHeight);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
