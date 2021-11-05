import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DB {
  var veri;

  void addData() {
    var box = Hive.box('sonuclar');
    box.add(veri);
    print(box.getAt(0));
  }

  listData(index) {
    var box = Hive.box('sonuclar');
    return box.getAt(index);
  }

  tableLenght() {
    var box = Hive.box('sonuclar');
    return box.length;
  }
}
