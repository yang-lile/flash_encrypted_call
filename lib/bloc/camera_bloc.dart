import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flash_encrypted_call/model/camera.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraOperation _op;

  CameraBloc(this._op) : super(CameraInitial()) {
    _op.initCamera().then((value) {
      this.add(CameraInited());
    });
  }

  @override
  Future<void> close() {
    _op.cameraController?.dispose();
    return super.close();
  }

  @override
  Stream<CameraState> mapEventToState(
    CameraEvent event,
  ) async* {
    if (event is CameraTakePicture) {
      yield CameraTaking(
        picMessage: [],
        picPath: [],
        cameraController: _op.cameraController,
      );
      _op.picMessage = [];
      _op.picPath = [];
      _op.picDatas = [];
      Stream stream = Stream.periodic(Duration(milliseconds: 1000)).take(30);
      // ignore: unused_local_variable
      await for (var item in stream) {
        final reback = await _op.getPicture();
        if (reback == 0) {
          await _op.analysePicture();
        } else {
          print(reback);
        }
        yield CameraTakingSwitch();
        yield CameraTaking(
          picMessage: _op.picMessage,
          picPath: _op.picPath,
          cameraController: _op.cameraController,
        );
      }
      final result = _op.decodedMessage(_op.picMessage);
      String back = "";
      if (result.isEmpty) {
        back = "没有检测到，请点击图片校验或者重试";
      } else if (result.length == 1) {
        back = "得到的数据是${result[0]}！";
      } else {
        back = "获取到多组数据，请点击图片校验或重试";
      }
      yield CameraTook(
        picPath: _op.picPath,
        picMessage: _op.picMessage,
        picDatas: _op.picDatas,
        cameraController: _op.cameraController,
        result: back,
      );
    }
    if (event is CameraInited) {
      yield CameraReady(
        cameraController: _op.cameraController,
      );
    }
  }
}
