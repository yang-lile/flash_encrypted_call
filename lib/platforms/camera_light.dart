import 'package:lamp_kotlin/lamp_kotlin.dart';

class SendMessage {
  bool _continue;

  List<bool> _encode(int number) {
    List<bool> codeList = [true, false, true, false];
    List<bool> _temp = [];
    // 转二进制
    while (number != 0) {
      _temp.add(number % 2 == 1);
      number ~/= 2;
    }
    // false补位并反转
    _temp.addAll(List.filled(3 - _temp.length, false));
    _temp.addAll(codeList.reversed.toList());
    _temp = _temp.reversed.toList();
    _temp.addAll(codeList.reversed.toList());
    return _temp;
  }

  List<int> _transcoding(List<bool> code) {
    var now = code[0];
    List<int> tcode = [];
    int count = 0;
    for (var item = 1; item < code.length; item++) {
      if (now == code[item]) {
        count++;
      } else {
        tcode.add(++count);
        count = 0;
        now = code[item];
      }
    }
    tcode.add(++count);
    return tcode;
  }

  // 该方法默认开头是1，并以1010的方式来发送数据
  Future<bool> sendMessage(int data) async {
    this._continue = true;
    List<int> _message = _transcoding(_encode(data));
    bool _pulse = false;
    for (var i in _message) {
      if (!_continue) {
        break;
      }
      _pulse = !_pulse;
      if (_pulse) {
        LampKotlin.openLamp();
      } else {
        LampKotlin.closeLamp();
      }
      await Future.delayed(Duration(milliseconds: 1000 * i));
    }
    LampKotlin.closeLamp();
    return _continue;
  }
}
