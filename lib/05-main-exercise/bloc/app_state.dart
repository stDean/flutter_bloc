import 'package:bloc_state_mgt/05-main-exercise/auth/auth_errors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required bool isLoading,
    AuthError? authError,
    required this.user,
    required this.images,
  }) : super(isLoading: isLoading, authError: authError);

  // checking for the equality of two loggedIn states
  @override
  bool operator ==(other) {
    final otherClassName = other;
    if (otherClassName is AppStateLoggedIn) {
      return isLoading == otherClassName.isLoading &&
          user.uid == otherClassName.user.uid &&
          images.length != otherClassName.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() => 'AppStateLoggedIn, images.length: ${images.length} ';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({required super.isLoading, super.authError});

  @override
  String toString() =>
      'AppStateLoggedOut isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required super.isLoading,
    super.authError,
  });

  @override
  String toString() =>
      'AppStateIsInRegistrationView isLoading = $isLoading, authError = $authError';
}
