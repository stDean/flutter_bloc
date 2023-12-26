import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppEvent {
  const AppEvent();
}

@immutable
class LoadNextImageEvent implements AppEvent {
  const LoadNextImageEvent();
}
