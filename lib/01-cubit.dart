import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

const List<String> names = ['foo', 'bar', 'bas'];

// this just extends the getRandomElement method on the Iterable library
// elementAt is a method on iterable and length is a prop on iterable
extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

// cubit state
class NameCubit extends Cubit<String?> {
  // the initial state is a nullable string
  NameCubit(super.initialState);

  // method to ick random name using the extension method on the iterable where the generic T === names
  // emit produces a new state
  void pickRandomName() => emit(names.getRandomElement());
}

class MyCubitWidget extends StatefulWidget {
  const MyCubitWidget({super.key});

  @override
  State<MyCubitWidget> createState() => _MyCubitWidgetState();
}

class _MyCubitWidgetState extends State<MyCubitWidget> {
  late final NameCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NameCubit(null);
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cubit'),
      ),
      body: StreamBuilder(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: const Text('Pick Random Name'),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data ?? ''),
                    button,
                  ],
                ),
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
