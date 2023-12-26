import 'dart:typed_data' show Uint8List;
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/app_state.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/bloc_event.dart';
import 'package:bloc_state_mgt/multibloc-04/bloc/app_bloc.dart';

extension ToList on String {
  Uint8List toUnit8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUnit8List();
final text2Data = 'Bar'.toUnit8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial state should be empty',
    build: () => AppBloc(urls: []),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );

  // load data and compare states
  blocTest<AppBloc, AppState>(
    'should load data',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) => bloc.add(
      const LoadNextImageEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        imgData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        imgData: text1Data,
        error: null,
      ),
    ],
  );

  // throw error from loader
  blocTest<AppBloc, AppState>(
    'should throw an error',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (bloc) => bloc.add(
      const LoadNextImageEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        imgData: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        imgData: null,
        error: Errors.dummy,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    'should load data from 2 urls',
    build: () => AppBloc(
      urls: [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (bloc) {
      bloc.add(
        const LoadNextImageEvent(),
      );
      bloc.add(
        const LoadNextImageEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        imgData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        imgData: text1Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        imgData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        imgData: text1Data,
        error: null,
      ),
    ],
  );
}
