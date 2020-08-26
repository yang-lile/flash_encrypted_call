import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flash_encrypted_call/tools/color_thief_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyCamera {
  CameraController cameraController;
  Future initCameraController;
  List<CameraDescription> _cameras;
  List<String> picPath = [];
  List<bool> picMessage = [];
  List<dynamic> picDatas = [];
  bool isScanning = false;

  MyCamera() {
    initCameraController = initCamera();
  }

  Future<void> initCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      print("${e.code},${e.description}");
    }
    cameraController = CameraController(_cameras[0], ResolutionPreset.low);
    return cameraController.initialize();
  }

  // TODO: 记得写销毁函数调用
  void dispose() {
    cameraController?.dispose();
  }

  void _showInSnackBar(String message) {
    // ignore: missing_return
    Builder(builder: (BuildContext context) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    });
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  /// 拍摄
  Future<int> _takePicture() async {
    if (!cameraController.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return 1;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${_timestamp()}.jpg';

    if (cameraController.value.isTakingPicture) {
      // // A capture is already pending, do nothing.
      // if taking, try take again.
      return await _takePicture();
    }

    try {
      await cameraController.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return 2;
    }
    picPath.add(filePath);
    return 0;
  }

  /// 解析图片
  Future<void> _analysePicture() async {
    final image = await getImageFromProvider(
      Image.file(
        File(picPath.last),
      ).image,
    );
    final palette = await myGetPaletteFromImage(image, 10, 1);

    // 保存一下数据
    picDatas.add(palette);

    bool flag;
    for (var item in palette) {
      flag = true;
      item.forEach((element) {
        if (element < 220) {
          flag = false;
        }
      });
      if (flag) {
        picMessage.add(flag);
        // break;
        return;
      }
    }

    picMessage.add(flag);
    return;
  }

  /// 对拍摄完成的图片做解析
  List<int> _decodedMessage(List<bool> p) {
    final aim = [true, false, true, false];
    List<int> result = [];
    for (var i = 0; i < p.length - 11; i++) {
      bool flag = true;
      for (var j = 0; j < 4; j++) {
        if (aim[j] != p[i + j]) {
          flag = false;
          break;
        }
      }
      for (var j = 0; j < 4; j++) {
        if (aim[3 - j] != p[i + j + 7]) {
          flag = false;
          break;
        }
      }
      if (flag) {
        result
            .add((p[4 + i] ? 4 : 0) + (p[5 + i] ? 2 : 0) + (p[6 + i] ? 1 : 0));
      }
    }
    return result;
  }

  /// 点击按钮事件
  void fabOnPressed() {
    // TODO
    _showInSnackBar("message");
    this.picMessage = [];
    this.picPath = [];
    this.picDatas = [];
    Stream stream = Stream.periodic(Duration(milliseconds: 600)).take(30);
    isScanning = true;
    stream.listen(
      (event) async {
        final reback = await _takePicture();
        if (reback == 0) {
          await _analysePicture();
        } else {
          print(reback);
        }
      },
    );
  }

  picturesDecode() {
    isScanning = false;
    final result = _decodedMessage(picMessage);
    if (result.isEmpty) {
      _showInSnackBar("没有检测到，请点击图片修改或者重试");
    } else if (result.length == 1) {
      _showInSnackBar("得到的数据是${result[0]}");
    } else {
      _showInSnackBar("获取到多组数据，请点击图片修改或重试");
    }
  }
}