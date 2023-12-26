import 'package:bloc_state_mgt/multibloc-04/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  BottomBloc({
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(waitForLoading: waitBeforeLoading, urls: urls);
}
