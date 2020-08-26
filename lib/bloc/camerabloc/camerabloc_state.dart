/// 状态有以下几种
/// 1. 未初始化
/// 2. 初始化了，就绪状态
/// 3. 拍摄中

part of 'camerabloc_bloc.dart';

@immutable
abstract class CamerablocState extends Equatable {
  final MyCamera camera;

  const CamerablocState({this.camera});

  @override
  List<Object> get props => [camera];
}

class CamerablocInitial extends CamerablocState {
  CamerablocInitial() : super() {
    print("CamerablocInitial");
  }
}

class CameraInitial extends CamerablocState {
  CameraInitial() : super() {
    print("CameraInitial");
  }
}

class CameraReady extends CamerablocState {
  CameraReady(MyCamera camera) : super(camera: camera);
}

class CameraTaking extends CamerablocState {
  CameraTaking(MyCamera camera) : super(camera: camera);
}
