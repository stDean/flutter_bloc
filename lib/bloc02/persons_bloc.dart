import 'package:bloc_state_mgt/bloc02/person_action.dart';
import 'package:bloc_state_mgt/bloc02/persons.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

// extension on iterable to check if two iterables are equal regardless on ordering
// iterable must be equal in length with "other" iterable
// and intersection between their sets muts be equal to the length
extension IsEqualToIgnoreOrdering<T> on Iterable<T> {
  bool isEqualToIgnoreOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

// the bloc state aka the output
// result when you fetch from the backend == iterable of persons
@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult({
    required this.persons,
    required this.isRetrievedFromCache,
  });

  @override
  String toString() =>
      'FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $persons)';

  @override
  bool operator ==(covariant FetchResult other) =>
      persons.isEqualToIgnoreOrdering(other.persons) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          // return value from cache
          final cachedPersons = _cache[url]!;
          final result = FetchResult(
            persons: cachedPersons,
            isRetrievedFromCache: true,
          );

          // send the result back
          emit(result);
        } else {
          // fetch persons
          // final persons = await getPersons(url.urlString);
          final loader = event.loader;
          final persons = await loader(url);
          // add it to the cache
          _cache[url] = persons;

          // get the response
          final result = FetchResult(
            persons: persons,
            isRetrievedFromCache: false,
          );

          emit(result);
        }
      },
    );
  }
}
