part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraTakePicture extends CameraEvent {
  const CameraTakePicture();
}

class CameraInited extends CameraEvent {
  const CameraInited();
}
