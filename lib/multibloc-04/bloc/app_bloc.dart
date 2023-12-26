import 'package:bloc/bloc.dart';
import 'dart:math' as math;
import 'package:bloc_state_mgt/multibloc-04/bloc/app_state.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/bloc_event.dart';
import 'package:flutter/services.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  AppBloc({
    AppBlocRandomUrlPicker? urlPicker,
    required Iterable<String> urls,
    Duration? waitForLoading,
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
        final bundle = NetworkAssetBundle(Uri.parse(url));
        final data = (await bundle.load(url)).buffer.asUint8List();
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
