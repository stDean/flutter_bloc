// import 'package:bloc_state_mgt/03-bloc.dart';
// import 'package:bloc_state_mgt/multibloc-04/view/home_page.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/view/app.dart';
// import 'package:bloc_state_mgt/bloc02/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import 'package:bloc_state_mgt/01-cubit.dart';
// import 'package:bloc_state_mgt/02-bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const App();
  }
}

// class App extends StatelessWidget {
//   const App({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Bloc State Management',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // home: const MyCubitWidget(),
//       // home: BlocProvider(
//       //   create: (_) => PersonsBloc(),
//       //   child: const MyFirstBlocWidget(),
//       // ),
//       // home: const MySecondBlocWidget(),
//       // home: const HomePage(),
//       home: const HomePage(),
//     );
//   }
// }
