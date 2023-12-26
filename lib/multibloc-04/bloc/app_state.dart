import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show immutable;

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
}
