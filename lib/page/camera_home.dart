import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flash_encrypted_call/bloc/camerabloc/camerabloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
  CamerablocBloc camerablocBloc;
  @override
  void initState() {
    super.initState();
    camerablocBloc = CamerablocBloc()..add(CameraInitial());
  }

  @override
  void dispose() {
    camerablocBloc.add(CameraDisposed());
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
                BlocBuilder<CamerablocBloc, CamerablocState>(
                  builder: (context, state) {
                    return Text(state.camera.picDatas[i].toString());
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // 预览
        Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: <Widget>[
            BlocBuilder<CamerablocBloc, CamerablocState>(
              builder: (context, state) {
                print(state);
                if (state is CameraInitialing) {
                  print("初始化中");
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CameraReady) {
                  print("初始化完成");

                  return AspectRatio(
                    aspectRatio:
                        state.camera.cameraController.value.aspectRatio,
                    child: CameraPreview(state.camera.cameraController),
                  );
                } else {
                  print(state);
                }
                return Container();
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
        BlocBuilder<CamerablocBloc, CamerablocState>(
          builder: (context, state) {
            return Wrap(
              children: <Widget>[
                for (int i = 0; i < state.camera.picMessage.length; i++)
                  Ink(
                    child: InkWell(
                      // 点击跳转到预览界面
                      onTap: () => _jumpPreviewPage(context, i),
                      child: _BuildPicturePreView(i: i, size: 50.0),
                    ),
                  ),
              ],
            );
          },
        )
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: BlocBuilder<CamerablocBloc, CamerablocState>(
        builder: (context, state) {
          return Stack(
            children: [
              Image.file(
                File(state.camera.picPath[i]),
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
                    color:
                        state.camera.picMessage[i] ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
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
