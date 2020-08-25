import 'package:flash_encrypted_call/platforms/camera_light.dart';
import 'package:flutter/material.dart';

class FlashHome extends StatefulWidget {
  @override
  _FlashHomeState createState() => _FlashHomeState();
}

class _FlashHomeState extends State<FlashHome> {
  var send = SendMessage();
  List<TextEditingController> controllers = [];
  List<String> datas;
  @override
  void initState() {
    super.initState();
    datas = List.generate(8, (index) => index.toString());
    for (var i = 0; i < 8; i++) {
      controllers.add(TextEditingController(text: datas[i].toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.send),
            title: Text("${datas[index]}"),
            onTap: () async => await send.sendMessage(index),
            onLongPress: () {
              buildShowDialog(context, index);
            },
          ),
        );
      },
    );
  }

  Future buildShowDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text("回车修改第${index + 1}项的文本"),
        content: TextField(
          controller: controllers[index],
          textInputAction: TextInputAction.done,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "在此处输入",
            prefixIcon: Icon(Icons.keyboard_arrow_right),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {},
          onEditingComplete: () {
            setState(() {
              datas[index] = controllers[index].text;
            });
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                datas[index] = controllers[index].text;
              });
              Navigator.pop(context);
            },
            child: Text("确认"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("取消"),
          )
        ],
      ),
    );
  }
}
