import 'package:bloc_state_mgt/bloc01/persons_bloc.dart';
import 'package:flutter/material.dart';

// import 'package:bloc_state_mgt/01-cubit.dart';
import 'package:bloc_state_mgt/02-bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bloc State Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyCubitWidget(),
      home: BlocProvider(
        create: (_) => PersonsBloc(),
        child: const MyFirstBlocWidget(),
      ),
    );
  }
}
