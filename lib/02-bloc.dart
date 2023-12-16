import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

// this is all main bloc action ie the EVENT aka the bloc input
@immutable
abstract class LoadAction {
  const LoadAction();
}

enum PersonsUrl { person1, person2 }

extension UrlString on PersonsUrl {
  String get urlString {
    switch (this) {
      case PersonsUrl.person1:
        return 'http://10.0.2.2:5500/api/persons1.json';
      case PersonsUrl.person2:
        return 'http://10.0.2.2:5500/api/persons2.json';
    }
  }
}

// action to load the person data
@immutable
class LoadPersonsAction extends LoadAction {
  final PersonsUrl url;

  const LoadPersonsAction({required this.url}) : super();
}

// the way the response data should be
@immutable
class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

// make request to fetch data
// then trandform the data into the Person format
Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((resp) => resp.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

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
      "FetchResult (isRetrievedFromCache = $isRetrievedFromCache, persons = $persons)";
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonsUrl, Iterable<Person>> _cache = {};

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
          final persons = await getPersons(url.urlString);

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

// this makes the iterable work like normal list
extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyFirstBlocWidget extends StatelessWidget {
  const MyFirstBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc One"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonsAction(url: PersonsUrl.person1));
                },
                child: const Text('Load Json #One'),
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<PersonsBloc>()
                      .add(const LoadPersonsAction(url: PersonsUrl.person2));
                },
                child: const Text('Load Json #Two'),
              ),
            ],
          ),
          // this listenings to the change in bloc state
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.persons != currentResult?.persons;
            },
            builder: ((context, fetchResult) {
              fetchResult?.log();

              final persons = fetchResult?.persons;
              if (persons == null) {
                return const SizedBox();
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                    );
                  },
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
