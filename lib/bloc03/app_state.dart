import 'package:bloc_state_mgt/models03.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:collection/collection.dart';

// comparing 2 iterables
extension UnorderedEquality on Object {
  bool isEqualTo(other) =>
      const DeepCollectionEquality.unordered().equals(this, other);
}

@immutable
class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandler? loginHandler;
  final Iterable<Note>? fetchedNotes;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandler,
    required this.fetchedNotes,
  });

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandler = null,
        fetchedNotes = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandler': loginHandler,
        'notes': fetchedNotes
      }.toString();

// equality in App State!!
  @override
  bool operator ==(covariant AppState other) {
    final otherPropsAreEqual = isLoading == other.isLoading &&
        loginError == other.loginError &&
        loginHandler == other.loginHandler;

    if (fetchedNotes == null && other.fetchedNotes == null) {
      return otherPropsAreEqual;
    } else {
      return otherPropsAreEqual &&
          (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? false);
    }
  }

  @override
  int get hashCode => Object.hash(
        isLoading,
        loginError,
        loginHandler,
        fetchedNotes,
      );
}
