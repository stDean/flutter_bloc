import 'package:bloc/bloc.dart';
import 'dart:math' as math;
import 'package:bloc_state_mgt/multibloc-04/bloc/app_state.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/bloc_event.dart';
import 'package:flutter/services.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();
  Future<Uint8List> _loader(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((byteData) => byteData.buffer.asUint8List());

  AppBloc({
    AppBlocRandomUrlPicker? urlPicker,
    required Iterable<String> urls,
    Duration? waitForLoading,
    AppBlocUrlLoader? urlLoader,
  }) : super(const AppState.empty()) {
    on<LoadNextImageEvent>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          imgData: null,
          error: null,
        ),
      );

      final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        if (waitForLoading != null) {
          await Future.delayed(waitForLoading);
        }
        final data = await (urlLoader ?? _loader)(url);
        emit(
          AppState(
            isLoading: false,
            imgData: data,
            error: null,
          ),
        );
      } catch (e) {
        emit(
          AppState(
            isLoading: false,
            imgData: null,
            error: e,
          ),
        );
      }
    });
  }
}
