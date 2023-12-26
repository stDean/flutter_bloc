import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show immutable;

extension Comparison<T> on List<T> {
  bool isEqual(List<T> other) {
    if (identical(this, other)) {
      return true;
    }

    if (length != other.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }

    return true;
  }
}

@immutable
class AppState {
  final bool isLoading;
  final Uint8List? imgData;
  final Object? error;

  const AppState({
    required this.isLoading,
    required this.imgData,
    required this.error,
  });

  const AppState.empty()
      : isLoading = false,
        imgData = null,
        error = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'error': error,
        'imgData': imgData,
      }.toString();

  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading &&
      (imgData ?? []).isEqual(other.imgData ?? []) &&
      error == other.error;

  @override
  int get hashCode => Object.hash(
        isLoading,
        imgData,
        error,
      );
}
