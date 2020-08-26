import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flash_encrypted_call/bloc/camerabloc/camerabloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraHome extends StatefulWidget {
  final CamerablocState cameraState;
  CameraHome(this.cameraState);
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  CamerablocState cameraState;

  @override
  void initState() {
    super.initState();
    cameraState = widget.cameraState;
  }

  @override
  void dispose() {
    cameraState.camera.dispose();
    super.dispose();
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
                _BuildPicturePreView(i: i, size: 300.0),
                Text(cameraState.camera.picDatas[i].toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _cameraController = cameraState.camera.cameraController;

    return ListView(
      children: <Widget>[
        // 预览
        Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: <Widget>[
            FutureBuilder(
              future: cameraState.camera.initCameraController,
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
            for (int i = 0; i < cameraState.camera.picMessage.length; i++)
              Ink(
                child: InkWell(
                  // 点击跳转到预览界面
                  onTap: () => _jumpPreviewPage(context, i),
                  child: _BuildPicturePreView(i: i, size: 50.0),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BuildPicturePreView extends StatelessWidget {
  const _BuildPicturePreView({
    Key key,
    @required this.i,
    @required this.size,
  }) : super(key: key);

  final int i;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cameraState = BlocProvider.of<CamerablocBloc>(context).state;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Stack(
        children: [
          Image.file(
            File(cameraState.camera.picPath[i]),
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
                color: cameraState.camera.picMessage[i]
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ],
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
