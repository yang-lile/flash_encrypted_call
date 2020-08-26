import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flash_encrypted_call/bloc/camerabloc/MyCamera.dart';
import 'package:meta/meta.dart';

part 'camerabloc_event.dart';
part 'camerabloc_state.dart';

class CamerablocBloc extends Bloc<CamerablocEvent, CamerablocState> {
  CamerablocBloc() : super(CamerablocInitial());

  CamerablocState get initialState => CameraInitial();

  MyCamera _camera = MyCamera();

  @override
  Stream<CamerablocState> mapEventToState(
    CamerablocEvent event,
  ) async* {
    if (event is CameraTakePicture) {
      _camera.fabOnPressed();
      yield CameraTaking(_camera);
    }
    if (event is CameraDecrypt) {
      _camera.picturesDecode();
      yield CameraReady(_camera);
    }
  }
}
