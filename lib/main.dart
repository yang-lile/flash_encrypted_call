import 'package:flash_encrypted_call/homepage.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '加密通话手电筒',
      home: HomePage(
        status: HomePageStatus.FLASH,
      ),
    );
  }
}
