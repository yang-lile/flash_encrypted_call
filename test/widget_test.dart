// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flash_encrypted_call/page/camera_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "相机布局",
    (WidgetTester tester) async {
      StatefulBuilder(
        builder: (BuildContext context, setState) {
          return MaterialApp(
            title: "jaf",
            home: CameraHome(),
          );
        },
      );
    },
  );
}
