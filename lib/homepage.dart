import 'package:flash_encrypted_call/bloc/camerabloc/camerabloc_bloc.dart';
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
    // 相机的state
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.lightbulb_outline,
            ),
            title: Text(
              _getAppBarTitle(0),
            ),
            activeIcon: Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).accentColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
            ),
            title: Text(
              _getAppBarTitle(1),
            ),
            activeIcon: Icon(
              Icons.camera_alt,
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() {
                _homePageStatus = HomePageStatus.FLASH;
                _currentIndex = 0;
              });
              break;
            case 1:
              setState(() {
                _homePageStatus = HomePageStatus.CAMERA;
                _currentIndex = 1;
              });
              break;
          }
        },
      ),
      body: _HomeBody(homePageStatus: _homePageStatus),
      floatingActionButton: this._currentIndex == 0
          ? FloatingActionButton(
              heroTag: "FAB_tag",
              child: Icon(Icons.link),
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
          : null,
    );
  }
}

class _CameraAction extends StatelessWidget {
  const _CameraAction({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CamerablocBloc, CamerablocState>(
      cubit: CamerablocBloc(),
      builder: (context, state) {
        if (state is CameraReady) {
          return FloatingActionButton(
            heroTag: "FAB_tag",
            child: Icon(Icons.camera_alt),
            onPressed: () {
              CamerablocBloc().add(CameraTakePicture());
            },
          );
        } else {
          return AbsorbPointer(
            child: FloatingActionButton(
              heroTag: "FAB_tag",
              child: Icon(Icons.cached),
              onPressed: () {},
            ),
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
        BlocProvider(
          lazy: false,
          create: (context) => CamerablocBloc(),
          child: CameraHome(),
        );
    }
    return Container();
  }
}
