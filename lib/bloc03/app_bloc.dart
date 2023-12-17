import 'package:bloc/bloc.dart';
import 'package:bloc_state_mgt/apis/login_api.dart';
import 'package:bloc_state_mgt/apis/notes_api.dart';
import 'package:bloc_state_mgt/bloc03/app_actions.dart';
import 'package:bloc_state_mgt/bloc03/app_state.dart';
import 'package:bloc_state_mgt/models03.dart';

class AppBloc extends Bloc<AppActions, AppState> {
  final LoginApiProtocol loginApi;
  final NoteApiProtocol noteApi;
  final LoginHandler acceptedLoginHandle;

  AppBloc({
    required this.loginApi,
    required this.noteApi,
    required this.acceptedLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      // start loading
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandler: null,
          fetchedNotes: null,
        ),
      );

      // log user in
      // the loginHandler will return foobar
      final loginHandler = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandler == null ? LoginError.invalidHandle : null,
          loginHandler: loginHandler,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandler: state.loginHandler,
          fetchedNotes: null,
        ),
      );

      // check for correct token
      final loginHandler = state.loginHandler;
      if (loginHandler != acceptedLoginHandle) {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginError.invalidHandle,
            loginHandler: loginHandler,
            fetchedNotes: null,
          ),
        );

        return;
      }

      final notes = await noteApi.getNotes(loginHandler: loginHandler!);
      emit(
        AppState(
          isLoading: false,
          loginError: null,
          loginHandler: loginHandler,
          fetchedNotes: notes,
        ),
      );
    });
  }
}
