// [true,false,true,false,true,false,false,false,true,false,true,];
// 4,3,4
List<int> _decodedMessage(List<bool> p) {
  final aim = [true, false, true, false];
  List<int> result = [];
  for (var i = 0; i < p.length - 11; i++) {
    bool flag = true;
    for (var j = 0; j < 4; j++) {
      if (aim[j] != p[i + j]) {
        flag = false;
        break;
      }
    }
    for (var j = 0; j < 4; j++) {
      if (aim[3 - j] != p[i + j + 7]) {
        flag = false;
        break;
      }
    }
    if (flag) {
      result.add((p[4+i] ? 4 : 0) + (p[5+i] ? 2 : 0) + (p[6+i] ? 1 : 0));
    }
  }
  return result;
}

main(List<String> args) async {
  List<bool> picMessage = [
    true,
    false,
    true,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    true,
    true,
    false,
    true,
    false,
    true,
    true,
    true,
    false,
    false,
    false,
    true,
  ];
  final r = _decodedMessage(picMessage);
  print(r);
}
