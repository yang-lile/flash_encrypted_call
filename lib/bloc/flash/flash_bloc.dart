import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'flash_event.dart';
part 'flash_state.dart';

class FlashBloc extends Bloc<FlashEvent, FlashState> {
  FlashBloc() : super(FlashInitial());

  @override
  Stream<FlashState> mapEventToState(
    FlashEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
