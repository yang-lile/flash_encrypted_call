import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'camerabloc_event.dart';
part 'camerabloc_state.dart';

class CamerablocBloc extends Bloc<CamerablocEvent, CamerablocState> {
  CamerablocBloc() : super(CamerablocInitial());

  @override
  Stream<CamerablocState> mapEventToState(
    CamerablocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
