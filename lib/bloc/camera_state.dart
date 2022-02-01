part of 'camera_bloc.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {
  const CameraInitial();
}

class CameraReady extends CameraState {
  const CameraReady({this.cameraController});

  final CameraController cameraController;

  @override
  List<Object> get props => [this.cameraController];
}

class CameraTaking extends CameraState {
  final List<String> picPath;
  final List<bool> picMessage;
  final CameraController cameraController;

  const CameraTaking({
    this.cameraController,
    this.picMessage,
    this.picPath,
  });

  @override
  List<Object> get props => [
        this.cameraController,
        this.picMessage,
        this.picPath,
      ];
}

class CameraTakingSwitch extends CameraState {
  const CameraTakingSwitch();
}

class CameraTook extends CameraState {
  final List<String> picPath;
  final List<bool> picMessage;
  final List<dynamic> picDatas;
  final CameraController cameraController;
  final String result;

  const CameraTook({
    this.result,
    this.cameraController,
    this.picDatas,
    this.picPath,
    this.picMessage,
  });

  @override
  List<Object> get props => [
        this.result,
        this.cameraController,
        this.picDatas,
        this.picPath,
        this.picMessage,
      ];
}
