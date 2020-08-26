/// 事件有以下几种事件
/// 1. 拍照事件
/// 2. 取消拍照事件
/// 3. 修改拍摄失误事件
/// 4. 拍摄完成的解密事件

part of 'camerabloc_bloc.dart';

@immutable
abstract class CamerablocEvent extends Equatable {
  const CamerablocEvent();

  List<Object> get props => [];
}

class CameraTakePicture extends CamerablocEvent {}

class CameraDecrypt extends CamerablocEvent {}
