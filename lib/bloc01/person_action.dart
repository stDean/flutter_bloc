import 'package:bloc_state_mgt/bloc01/persons.dart';
import 'package:flutter/foundation.dart' show immutable;

// enum PersonsUrl { person1, person2 }

// extension UrlString on PersonsUrl {
//   String get urlString {
//     switch (this) {
//       case PersonsUrl.person1:
//         return 'http://10.0.2.2:5500/api/persons1.json';
//       case PersonsUrl.person2:
//         return 'http://10.0.2.2:5500/api/persons2.json';
//     }
//   }
// }

const person1Url = 'http://10.0.2.2:5500/api/persons1.json';
const person2Url = 'http://10.0.2.2:5500/api/persons2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

// this is all main bloc action ie the EVENT aka the bloc input
@immutable
abstract class LoadAction {
  const LoadAction();
}

// action to load the person data
@immutable
class LoadPersonsAction extends LoadAction {
  final String url;
  final PersonLoader loader;

  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}
