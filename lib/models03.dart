import 'package:flutter/foundation.dart' show immutable;

enum LoginError { invalidHandle }

// model of the login
@immutable
class LoginHandler {
  final String token;

  const LoginHandler({required this.token});

  const LoginHandler.fooBar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandler other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle: (token = $token)';
}

// notes model
@immutable
class Note {
  final String title;

  const Note({required this.title});

  @override
  String toString() => 'Note: (title = $title)';
}

final mockNote = Iterable.generate(
  4,
  (i) => Note(title: 'Note ${i + 1}'),
);
