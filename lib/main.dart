import 'package:flash_encrypted_call/homepage.dart';
import 'package:flash_encrypted_call/model/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/camera_bloc.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final CameraOperation _operation = CameraOperation();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '加密手电筒',
      home: BlocProvider(
        create: (context) => CameraBloc(_operation),
        child: HomePage(
          status: HomePageStatus.FLASH,
        ),
      ),
    );
  }
}
