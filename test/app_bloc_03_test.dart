import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_state_mgt/bloc03/app_actions.dart';
import 'package:bloc_state_mgt/bloc03/app_bloc.dart';
import 'package:bloc_state_mgt/bloc03/app_state.dart';
import 'package:bloc_state_mgt/apis/login_api.dart';
import 'package:bloc_state_mgt/apis/notes_api.dart';
import 'package:bloc_state_mgt/models03.dart';

Iterable<Note> mockNotes = [
  const Note(title: 'Note 1'),
  const Note(title: 'Note 2'),
  const Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi extends NoteApiProtocol {
  final LoginHandler acceptedLoginHandler;
  final Iterable<Note>? noteToReturnForAcceptedLoginHandler;

  const DummyNotesApi({
    required this.acceptedLoginHandler,
    required this.noteToReturnForAcceptedLoginHandler,
  });

// for the initial state where app state is empty
// an empty constructor
  const DummyNotesApi.empty()
      : acceptedLoginHandler = const LoginHandler.fooBar(),
        noteToReturnForAcceptedLoginHandler = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandler loginHandler}) async {
    if (loginHandler == acceptedLoginHandler) {
      return noteToReturnForAcceptedLoginHandler;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi extends LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandler handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandler.fooBar();

  @override
  Future<LoginHandler?> login({
    required String email,
    required String password,
  }) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

const acceptedLoginHandle = LoginHandler(token: 'ABC');

void main() {
  blocTest<AppBloc, AppState>(
    'initial state should be AppState.empty() ',
    build: () => AppBloc(
        loginApi: const DummyLoginApi.empty(),
        noteApi: const DummyNotesApi.empty(),
        acceptedLoginHandle: acceptedLoginHandle),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    'can we log in with correct credentials?',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@foo.com',
        acceptedPassword: 'hello',
        handleToReturn: acceptedLoginHandle,
      ),
      noteApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'foo@foo.com',
        password: 'hello',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandler: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandler: acceptedLoginHandle,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'should not log in with incorrect credentials',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@foo.com',
        acceptedPassword: 'hello',
        handleToReturn: acceptedLoginHandle,
      ),
      noteApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(
        email: 'foo@baz.com',
        password: 'hello',
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandler: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginError.invalidHandle,
        loginHandler: null,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'log in user should get notes',
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: 'foo@foo.com',
        acceptedPassword: 'hello',
        handleToReturn: acceptedLoginHandle,
      ),
      noteApi: DummyNotesApi(
        acceptedLoginHandler: acceptedLoginHandle,
        noteToReturnForAcceptedLoginHandler: mockNotes,
      ),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(
          email: 'foo@foo.com',
          password: 'hello',
        ),
      );
      appBloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandler: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandler: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandler: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      AppState(
        isLoading: false,
        loginError: null,
        loginHandler: acceptedLoginHandle,
        fetchedNotes: mockNotes,
      ),
    ],
  );
}
