import 'package:bloc_state_mgt/apis/login_api.dart';
import 'package:bloc_state_mgt/apis/notes_api.dart';
import 'package:bloc_state_mgt/bloc03/app_actions.dart';
import 'package:bloc_state_mgt/bloc03/app_bloc.dart';
import 'package:bloc_state_mgt/bloc03/app_state.dart';
import 'package:bloc_state_mgt/dialogs/generic_dialog.dart';
import 'package:bloc_state_mgt/dialogs/loading_screen.dart';
import 'package:bloc_state_mgt/models03.dart';
import 'package:bloc_state_mgt/string03.dart';
import 'package:bloc_state_mgt/view/iterable_list_view.dart';
import 'package:bloc_state_mgt/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MySecondBlocWidget extends StatelessWidget {
  const MySecondBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        noteApi: NoteApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
          listener: (context, appState) {
            // take care of loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }

            // display errors in appState
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }

            // if logged in but no fetched notes, fetch it!
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandler == const LoginHandler.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
        ),
      ),
    );
  }
}
