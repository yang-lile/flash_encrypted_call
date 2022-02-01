import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flash_encrypted_call/bloc/camera_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraHome extends StatefulWidget {
  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> {
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
            body: BlocBuilder<CameraBloc, CameraState>(
              builder: (context, state) {
                if (state is CameraTook) {
                  return Column(
                    children: <Widget>[
                      _BuildPicturePreView(
                        i: i,
                        size: 300.0,
                        picMessage: state.picMessage,
                        picPath: state.picPath,
                      ),
                      Text(
                        state.picDatas[i].toString(),
                      ),
                    ],
                  );
                } else {
                  return Text("未知错误001");
                }
                // return Column(
                //   children: <Widget>[
                //     _BuildPicturePreView(
                //       i: i,
                //       size: 300.0,
                //       picMessage: GV.picMessage,
                //       picPath: GV.picPath,
                //     ),
                //     // Text(
                //     //   GV.picDatas[i].toString(),
                //     // ),
                //   ],
                // );
              },
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
            BlocBuilder<CameraBloc, CameraState>(
              builder: (context, state) {
                if (state is CameraReady) {
                  return AspectRatio(
                    aspectRatio: state.cameraController.value.aspectRatio,
                    child: CameraPreview(state.cameraController),
                  );
                } else if (state is CameraTook) {
                  return AspectRatio(
                    aspectRatio: state.cameraController.value.aspectRatio,
                    child: CameraPreview(state.cameraController),
                  );
                } else if (state is CameraTaking) {
                  return AspectRatio(
                    aspectRatio: state.cameraController.value.aspectRatio,
                    child: CameraPreview(state.cameraController),
                  );
                } else {
                  return CircularProgressIndicator();
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
        Center(
          child: BlocBuilder<CameraBloc, CameraState>(
            builder: (context, state) {
              if (state is CameraTaking) {
                return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < state.picPath.length; i++)
                        Ink(
                          child: InkWell(
                            // 点击跳转到预览界面
                            onTap: () => _jumpPreviewPage(context, i),
                            child: _BuildPicturePreView(
                              i: i,
                              size: 50.0,
                              picPath: state.picPath,
                              picMessage: state.picMessage,
                            ),
                          ),
                        ),
                    ]);
              } else if (state is CameraTook) {
                return Wrap(children: <Widget>[
                  for (int i = 0; i < state.picPath.length; i++)
                    Ink(
                      child: InkWell(
                        // 点击跳转到预览界面
                        onTap: () => _jumpPreviewPage(context, i),
                        child: _BuildPicturePreView(
                          i: i,
                          size: 50.0,
                          picPath: state.picPath,
                          picMessage: state.picMessage,
                        ),
                      ),
                    ),
                ]);
              } else {
                return Container();
              }
            },
          ),
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
    @required this.picPath,
    @required this.picMessage,
  }) : super(key: key);

  final int i;
  final double size;
  final List picPath;
  final List picMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraTook) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Image.file(
                  File(state.picPath[i]),
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
                      color: state.picMessage[i] ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is CameraTaking) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                Image.file(
                  File(state.picPath[i]),
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
                      color: state.picMessage[i] ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: Text("什么都没有加载到。。。"),
          );
        }
      },
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
