import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flash_encrypted_call/tools/color_thief_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  CameraController _cameraController;
  Future _initCameraController;
  List<CameraDescription> _cameras;
  List<String> picPath = [];
  List<bool> picMessage = [];
  List<dynamic> picDatas = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // 初始化给异步初始化，初始化结束生成相机预览
    _initCameraController = initCamera();
  }

  /// 初始化相机
  initCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      print("${e.code},${e.description}");
    }
    _cameraController = CameraController(_cameras[0], ResolutionPreset.low);
    return _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void showInSnackBar(String message) {
    // ignore: missing_return
    Builder(builder: (BuildContext context) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    });
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  /// 拍摄
  Future<int> _takePicture() async {
    if (!_cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return 1;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (_cameraController.value.isTakingPicture) {
      // // A capture is already pending, do nothing.
      // if taking, try take again.
      return await _takePicture();
    }

    try {
      await _cameraController.takePicture(filePath);
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
        setState(() {
          picMessage.add(flag);
        });
        // break;
        return;
      }
    }

    setState(() {
      picMessage.add(flag);
    });
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
  void _fabOnPressed() {
    // TODO
    showInSnackBar("message");
    this.picMessage = [];
    this.picPath = [];
    this.picDatas = [];
    Stream stream = Stream.periodic(Duration(milliseconds: 600)).take(30);
    setState(() {
      _isScanning = true;
    });
    stream.listen(
      (event) async {
        final reback = await _takePicture();
        if (reback == 0) {
          await _analysePicture();
        } else {
          print(reback);
        }
      },
      onDone: () {
        setState(() {
          _isScanning = false;
        });
        final result = _decodedMessage(picMessage);
        if (result.isEmpty) {
          showInSnackBar("没有检测到，请点击图片修改或者重试");
        } else if (result.length == 1) {
          showInSnackBar("得到的数据是${result[0]}");
        } else {
          showInSnackBar("获取到多组数据，请点击图片修改或重试");
        }
      },
    );
  }

  /// 图片的浏览
  Padding _buildPicturePreView(int i, double size) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Image.file(
            File(picPath[i]),
            height: size,
            width: size,
            alignment: Alignment.center,
          ),
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: picMessage[i] ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 跳转事件
  /// 跳转至预览传入一个下标
  Future _jumpPreviewPage(BuildContext context, int i) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("第${i + 1}张图片信息"),
            ),
            body: Column(
              children: <Widget>[
                _buildPicturePreView(i, 300.0),
                Text(picDatas[i].toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          // 预览
          Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: <Widget>[
              FutureBuilder(
                future: _initCameraController,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              FractionallySizedBox(
                widthFactor: 0.1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(
                        color: Colors.red,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 拍摄结果预览
          Wrap(
            children: <Widget>[
              for (int i = 0; i < picMessage.length; i++)
                Ink(
                  child: InkWell(
                    // 点击跳转到预览界面
                    onTap: () => _jumpPreviewPage(context, i),
                    child: _buildPicturePreView(i, 50.0),
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: AbsorbPointer(
        absorbing: _isScanning,
        child: FloatingActionButton(
          heroTag: "FAB_tag",
          child: _isScanning ? Icon(Icons.cached) : Icon(Icons.camera_alt),
          onPressed: _fabOnPressed,
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//   const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

//   void cropperimage() async {
//     getImageFromProvider(
//       Image.file(
//         File(imagePath),
//       ).image,
//     ).then(
//       (value) => myGetPaletteFromImage(value, 10, 1).then(
//         (value) => print(value),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     cropperimage();
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(
//         File(imagePath),
//       ),
//     );
//   }
// }
