import 'package:bloc_state_mgt/05-main-exercise/bloc/app_bloc.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_event.dart';
import 'package:bloc_state_mgt/05-main-exercise/bloc/app_state.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/dialogs/show_auth_error.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/loading/loading_screen.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/view/login_view.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/view/photo_gallery_view.dart';
import 'package:bloc_state_mgt/05-main-exercise/lib/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        title: 'Photo Library',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                context: context,
                authError: authError,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else {
              // should never happen
              return Container();
            }
          },
        ),
      ),
    );
  }
}
