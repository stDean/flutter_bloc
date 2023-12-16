import 'package:bloc_state_mgt/models03.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NoteApiProtocol {
  const NoteApiProtocol();

// login user should be able to get notes
  Future<Iterable<Note>?> getNotes({required LoginHandler loginHandler});
}

@immutable
class NoteApi implements NoteApiProtocol {
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandler loginHandler}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandler == const LoginHandler.fooBar() ? mockNote : null,
      );
}
