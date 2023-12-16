import 'package:bloc_state_mgt/bloc02/person_action.dart';
import 'package:bloc_state_mgt/bloc02/persons.dart';
import 'package:bloc_state_mgt/bloc02/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

// mocking the persons iterable
const mockedPerson = [
  Person(age: 20, name: 'Dean'),
  Person(age: 50, name: 'Dean2'),
];

const mockedPerson2 = [
  Person(age: 20, name: 'Jimmy'),
  Person(age: 50, name: 'Jimmy2'),
];

// mocking the loader function
// the loader
Future<Iterable<Person>> mockGetPerson1(String _) => Future.value(mockedPerson);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group('testing persons bloc', () {
    late PersonsBloc bloc;

    // all test have this instance
    setUp(() => {bloc = PersonsBloc()});

    blocTest<PersonsBloc, FetchResult?>(
      'test initial state',
      build: () => bloc,
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
      'mock retrieving persons1 from 1st iterable',
      build: () => bloc,
      // actions emitted
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'url1',
            loader: mockGetPerson1,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'url1',
            loader: mockGetPerson1,
          ),
        );
      },
      // what to expect from the actions(result)
      expect: () => [
        const FetchResult(persons: mockedPerson, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPerson, isRetrievedFromCache: true),
      ],
    );

    blocTest<PersonsBloc, FetchResult?>(
      'mock retrieving persons2 from 2nd iterable',
      build: () => bloc,
      // actions
      act: (bloc) {
        bloc.add(
          const LoadPersonsAction(
            url: 'url2',
            loader: mockGetPerson2,
          ),
        );
        bloc.add(
          const LoadPersonsAction(
            url: 'url2',
            loader: mockGetPerson2,
          ),
        );
      },
      // what to expect from the actions
      expect: () => [
        const FetchResult(persons: mockedPerson2, isRetrievedFromCache: false),
        const FetchResult(persons: mockedPerson2, isRetrievedFromCache: true),
      ],
    );
  });
}
