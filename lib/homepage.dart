import 'package:flash_encrypted_call/bloc/camera_bloc.dart';
import 'package:flash_encrypted_call/page/camera_home.dart';
import 'package:flash_encrypted_call/page/flash_home.dart';
import 'package:flutter/material.dart';
import 'package:lamp_kotlin/lamp_kotlin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum HomePageStatus { FLASH, CAMERA }

class HomePage extends StatefulWidget {
  final HomePageStatus status;

  HomePage({this.status, key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageStatus _homePageStatus;
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _homePageStatus = widget.status;
    _currentIndex = 0;
  }

  String _getAppBarTitle([int index]) {
    var appBarTitle = ["加密手电筒", "解密相机"];
    if (index != null && index < appBarTitle.length && index >= 0) {
      return appBarTitle[index];
    }
    switch (_homePageStatus) {
      case HomePageStatus.FLASH:
        return appBarTitle[0];
      case HomePageStatus.CAMERA:
        return appBarTitle[1];
      default:
    }
    return "null";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("使用说明书"),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: "感谢使用本沙雕软件，反正你明明喊得到的人，偏要和他打闪光灯，这个我也没办法。\n",
                            style: TextStyle(
                              color: Colors.grey[300],
                            ),
                          ),
                          TextSpan(
                              text:
                                  "软件采用了原始但有用的莫氏信号来传输数据,需要你和你的好基友约定好每个项目的意义,通过长按可以修改.\n"),
                          TextSpan(
                              text: "使用步骤:\n1. 发送方使用手电筒下方的测试按钮来发送自己的位置信息.\n"),
                          TextSpan(
                              text: "2. 接受方同样使用该按钮回应,发送方停止三秒后按列表的项目发送数据.\n"),
                          TextSpan(
                              text:
                                  "3. 同时接受方要在三秒内,在解密相机里按右侧按钮打开相机,并用圆形准心对准发送方的光源达成连线.\n"),
                          TextSpan(
                              text: "4. 18秒30张照片后,会弹出一个按钮,点击即可查看接收到的信息.\n"),
                        ]),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: _currentIndex == 0
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: IconButton(
                icon: Icon(Icons.lightbulb_outline),
                onPressed: () {
                  setState(() {
                    _homePageStatus = HomePageStatus.FLASH;
                    _currentIndex = 0;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  setState(() {
                    _homePageStatus = HomePageStatus.CAMERA;
                    _currentIndex = 1;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: _HomeBody(homePageStatus: _homePageStatus),
      floatingActionButton: this._currentIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.wb_incandescent),
              onPressed: () {
                LampKotlin.openLamp();
                Future.delayed(Duration(seconds: 1)).then(
                  (value) => LampKotlin.closeLamp(),
                );
              },
            )
          : _CameraAction(),
      floatingActionButtonLocation: this._currentIndex == 0
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endTop,
    );
  }
}

class _CameraAction extends StatelessWidget {
  const _CameraAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraReady) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                child: Icon(Icons.camera_alt),
                onPressed: () {
                  context.watch<CameraBloc>().add(CameraTakePicture());
                },
              ),
            ],
          );
        } else if (state is CameraTook) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                child: Icon(Icons.camera_alt),
                onPressed: () {
                  context.watch<CameraBloc>().add(CameraTakePicture());
                },
              ),
              SizedBox(height: 20),
              FloatingActionButton(
                child: Icon(Icons.library_books),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("收到结果："),
                        content: Text(state.result),
                      );
                    },
                  );
                },
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AbsorbPointer(
                child: FloatingActionButton(
                  child: Icon(Icons.cached),
                  onPressed: () {},
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({
    Key key,
    @required HomePageStatus homePageStatus,
  })  : _homePageStatus = homePageStatus,
        super(key: key);

  final HomePageStatus _homePageStatus;

  @override
  Widget build(BuildContext context) {
    switch (_homePageStatus) {
      case HomePageStatus.FLASH:
        return FlashHome();
      case HomePageStatus.CAMERA:
        return CameraHome();
    }
    return Container();
  }
}
