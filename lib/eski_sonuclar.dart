import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:kkcontrol/database.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EskiSonuclar extends StatefulWidget {
  const EskiSonuclar({Key? key}) : super(key: key);

  @override
  _EskiSonuclarState createState() => _EskiSonuclarState();
}

class _EskiSonuclarState extends State<EskiSonuclar> {
  DB veritabani = DB();

  @override
  Widget build(BuildContext context) {
    // backing data
    FocusScope.of(context).unfocus();
    var box = Hive.box('sonuclar');
 
    return ListView.builder(
      reverse: false,
      shrinkWrap: true,
      itemCount: veritabani.tableLenght(),
      itemBuilder: (context, index) {
        int reverseindex = veritabani.tableLenght() - 1 - index;

        return GestureDetector(
          onLongPress: () {
            FlutterClipboard.copy(veritabani.listData(index))
                .then((value) => print('copied'));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: const Text('KOPYALANDI'),
              ),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text("${veritabani.listData(reverseindex)}"),
            ),
          ),
        );
      },
    );
  }
}
