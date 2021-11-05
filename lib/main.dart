import 'dart:io';

import "package:flutter/material.dart";
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kkcontrol/database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:clipboard/clipboard.dart';
import 'eski_sonuclar.dart';
import 'package:flutter/foundation.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if ((defaultTargetPlatform == TargetPlatform.iOS) ||
      (defaultTargetPlatform == TargetPlatform.android)) {
    print("girdi");
    final appDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDirectory.path);
    Hive.openBox('sonuclar');
  }

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
      ],
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String basDeger = 'KURU';
  String ortaDeger = 'KURU';
  String sonDeger = 'KURU';

  String basDegerKontaminant = '0-10';
  String ortaDegerKontaminant = '0-10';
  String sonDegerKontaminant = '0-10';

  final pistBasiTextControlBir = TextEditingController();
  final pistBasiTextControlIki = TextEditingController();
  final pistOrtasiTextControlBir = TextEditingController();
  final pistOrtasiTextControlIki = TextEditingController();
  final pistSonuTextControlBir = TextEditingController();
  final pistSonuTextControlIki = TextEditingController();
  final icaoKodu = TextEditingController();
  final pistKodu = TextEditingController();

  var hesapSonucu;
  var kontaminantYuzde = <String>['0-10', '11-25', '26-50', '51-75', '76-100'];
  var kirleticiTurleri = <String>[
    'KURU',
    'DON',
    'ISLAK',
    'SULU KAR',
    'KURU KAR',
    'ISLAK KAR',
    "SIKIŞMIŞ KAR (-15 VEYA DAHA SOĞUK)",
    'ISLAK (ISLAKKEN KAYGAN ZEMİN)',
    "SIKIŞMIŞ KAR ÜZERİ KURU VEYA ISLAK KAR",
    "SIKIŞMIŞ KAR (-15'DEN DAHA SICAK)",
    "SU BİRİKİNTİSİ (DURGUN SU)",
    "BUZLU",
    "ISLAK BUZ",
    "SIKIŞMIŞ KAR ÜZERİ SU",
    "BUZ ÜZERİ KURU KAR VEYA ISLAK KAR",
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: HexColor("##FAFAFA"),
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "Ana Ekran",
                  ),
                  Tab(
                    text: "Sonuçlar",
                  )
                ],
              ),
              title: const Center(
                child: Text(
                  "The Runway Condition Report (RCR)",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              backgroundColor: HexColor("#000000"),
            ),
            body: TabBarView(children: [
              SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: HexColor("#000000"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: icaoKodu,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Havalimanı ICAO Kodu"),
                                ),
                                SizedBox(height: 12),
                                TextField(
                                  controller: pistKodu,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Pist Numarası"),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Pist Başı",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.topCenter,
                                  color: HexColor("#000000"),
                                  child: SizedBox(height: 1),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Kontaminant (kirletici) türünü seçiniz."),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: basDeger,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            basDeger = newValue!;
                                          });
                                        },
                                        items: kirleticiTurleri
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Kontaminant üçte birlik kısmın, yüzde kaçını kaplamaktadır?"),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: basDegerKontaminant,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            basDegerKontaminant = newValue!;
                                          });
                                        },
                                        items: kontaminantYuzde
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  controller: pistBasiTextControlIki,
                                  onChanged: (text) {
                                    if (int.parse(pistBasiTextControlIki.text) >
                                        3) {
                                      if (KontaminantKontrol(basDeger)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Girilen derinlik değeri kontaminant türüyle eşleşmiyor!'),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (basDeger ==
                                          "SU BİRİKİNTİSİ (DURGUN SU)") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Girilen derinlik değeri kontaminant türüyle eşleşmiyor!'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          "Kontaminant derinliğini (mm) giriniz."),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: HexColor("#000000"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Pist Ortası",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.topCenter,
                                  color: HexColor("#000000"),
                                  child: SizedBox(height: 1),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Kontaminant (kirletici) türünü seçiniz."),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: ortaDeger,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            ortaDeger = newValue!;
                                          });
                                        },
                                        items: kirleticiTurleri
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Kontaminant üçte birlik kısmın, yüzde kaçını kaplamaktadır?"),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: ortaDegerKontaminant,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            ortaDegerKontaminant = newValue!;
                                          });
                                        },
                                        items: kontaminantYuzde
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  onChanged: (text) {
                                    if (int.parse(
                                            pistOrtasiTextControlIki.text) >
                                        3) {
                                      if (KontaminantKontrol(ortaDeger)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Girilen derinlik değeri kontaminant türüyle eşleşmiyor!'),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (ortaDeger ==
                                          "SU BİRİKİNTİSİ (DURGUN SU)") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Girilen derinlik değeri kontaminant türüyle eşleşmiyor!'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  controller: pistOrtasiTextControlIki,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          "Kontaminant derinliğini (mm) giriniz."),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: HexColor("#000000"),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Pist Sonu",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  alignment: Alignment.topCenter,
                                  color: HexColor("#000000"),
                                  child: SizedBox(height: 1),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Kontaminant (kirletici) türünü seçiniz."),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: sonDeger,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            sonDeger = newValue!;
                                          });
                                        },
                                        items: kirleticiTurleri
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black38),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          "Kontaminant üçte birlik kısmın, yüzde kaçını kaplamaktadır?"),
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        value: sonDegerKontaminant,
                                        elevation: 16,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            sonDegerKontaminant = newValue!;
                                          });
                                        },
                                        items: kontaminantYuzde
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (text) {
                                    if (int.parse(pistSonuTextControlIki.text) >
                                        3) {
                                      if (KontaminantKontrol(sonDeger)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Girilen derinlik değeri kontaminant türüyle eşleşmiyor!'),
                                          ),
                                        );
                                      }
                                    } else {
                                      if (sonDeger ==
                                          "SU BİRİKİNTİSİ (DURGUN SU)") {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.red,
                                            content: const Text(
                                                'Girilen derinlik değeri kontaminant türüyle eşleşmiyor!'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  controller: pistSonuTextControlIki,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText:
                                          "Kontaminant derinliğini (mm) giriniz."),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(240, 60),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              textStyle: TextStyle(fontSize: 20)),
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                  'SONUÇ',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  hesapSonucu = Hesapla(
                                          icaoKodu.text.toUpperCase(),
                                          pistKodu.text.toUpperCase(),
                                          basDegerKontaminant,
                                          basDeger,
                                          pistBasiTextControlIki.text,
                                          ortaDegerKontaminant,
                                          ortaDeger,
                                          pistOrtasiTextControlIki.text,
                                          sonDegerKontaminant,
                                          sonDeger,
                                          pistSonuTextControlIki.text)
                                      .toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        FlutterClipboard.copy(hesapSonucu)
                                            .then((value) => print('copied'));
                                      },
                                      child: const Text("KOPYALA")),
                                  TextButton(
                                      onPressed: () {
                                        Share.share(hesapSonucu);
                                      },
                                      child: const Text("PAYLAŞ")),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'ÇIK'),
                                    child: const Text('ÇIK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('HESAPLA'),
                        ),
                        SizedBox(
                          height: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: EskiSonuclar(),
              )
            ])),
      ),
    );
  }
}

Hesapla(icao, pistKodu, pistbasbir, pistbasiki, pistbasuc, pistortabir,
    pistortaiki, pistortauc, pistsonbir, pistsoniki, pistsonuc) {
  DB veritabani = DB();
  var f = DateFormat('MMdHHmm');
  var date = f.format(DateTime.now().toUtc());

  String sonuc = icao +
      " " +
      date +
      " " +
      pistKodu +
      "\n" +
      DurumKodu(pistbasiki, pistbasuc.toString()) +
      "/" +
      DurumKodu(pistortaiki, pistortauc.toString()) +
      "/" +
      DurumKodu(pistsoniki, pistsonuc.toString()) +
      "\n" +
      Yuvarlama(pistbasbir) +
      "/" +
      Yuvarlama(pistortabir) +
      "/" +
      Yuvarlama(pistsonbir) +
      "\n" +
      milimYuvarla(pistbasuc) +
      "/" +
      milimYuvarla(pistortauc) +
      "/" +
      milimYuvarla(pistsonuc) +
      "\n" +
      pistbasiki +
      "/" +
      pistortaiki +
      "/" +
      pistsoniki;
  veritabani.veri = sonuc;
  veritabani.addData();
  return sonuc;
}

milimYuvarla(deger) {
  String? sonuc;

  deger = int.parse(deger);
  if (deger < 3) {
    sonuc = "NR";
  }

  if (deger == 3) {
    sonuc = "03";
  }

  if (deger > 3 && deger <= 6) {
    sonuc = "06";
  }

  if (deger > 6 && deger <= 12) {
    sonuc = "12";
  }

  if (deger > 12 && deger <= 19) {
    sonuc = "19";
  }
  if (deger > 19 && deger <= 25) {
    sonuc = "25";
  }
  if (deger > 25 && deger <= 38) {
    sonuc = "38";
  }
  if (deger > 38 && deger <= 50) {
    sonuc = "50";
  }
  if (deger > 50 && deger <= 75) {
    sonuc = "75";
  }

  if (deger > 75 && deger <= 100) {
    sonuc = "100";
  }
  if (deger > 100 && deger <= 125) {
    sonuc = "125";
  }

  return sonuc;
}

DurumKodu(deger, milim) {
  String? sonuc;
  milim = int.parse(milim);
  if (deger == "KURU") {
    sonuc = "6";
  }
  if (deger == "DON") {
    sonuc = "5";
  }
  if (deger == "ISLAK" && milim <= 3) {
    sonuc = "5";
  }

  if (deger == "ISLAK" && milim > 3) {}

  if (deger == "SU BİRİKİNTİSİ (DURGUN SU)" && milim > 3) {
    sonuc = "2";
  }

  if (deger == "SULU KAR" && milim <= 3) {
    sonuc = "5";
  }

  if (deger == "KURU KAR" && milim <= 3) {
    sonuc = "5";
  }
  if (deger == "ISLAK KAR" && milim <= 3) {
    sonuc = "5";
  }
  if (deger == "KURU KAR" && milim > 3) {
    sonuc = "3";
  }
  if (deger == "ISLAK KAR" && milim > 3) {
    sonuc = "3";
  }
  if (deger == "SULU KAR" && milim > 3) {
    sonuc = "2";
  }
  if (deger == "SIKIŞMIŞ KAR (-15 VEYA DAHA SOĞUK)") {
    sonuc = "4";
  }
  if (deger == "SIKIŞMIŞ KAR (-15'DEN DAHA SICAK)") {
    sonuc = "3";
  }

  if (deger == "SIKIŞMIŞ KAR ÜZERİ KURU VEYA ISLAK KAR") {
    sonuc = "3";
  }
  if (deger == "ISLAK (ISLAKKEN KAYGAN ZEMİN)") {
    sonuc = "3";
  }

  if (deger == "BUZLU") {
    sonuc = "1";
  }
  if (deger == "ISLAK BUZ") {
    sonuc = "0";
  }
  if (deger == "SIKIŞMIŞ KAR ÜZERİ SU") {
    sonuc = "0";
  }
  if (deger == "BUZ ÜZERİ KURU KAR VEYA ISLAK KAR") {
    sonuc = "0";
  }

  print("durum kodu $sonuc");
  return sonuc;
}

Yuvarlama(deger) {
  String? sonuc;

  if (deger == '0-10') {
    sonuc = "NR";
  }
  if (deger == '11-25') {
    sonuc = "25";
  }

  if (deger == '26-50') {
    sonuc = "50";
  }

  if (deger == '51-75') {
    sonuc = "75";
  }

  if (deger == '76-100') {
    sonuc = "100";
  }

  return sonuc;
}

KontaminantKontrol(basDeger) {
  if (basDeger == "SULU KAR") {
    return false;
  }
  if (basDeger == "KURU KAR") {
    return false;
  }
  if (basDeger == "ISLAK KAR") {
    return false;
  }
  if (basDeger == "SU BİRİKİNTİSİ (DURGUN SU)") {
    return false;
  } else {
    return true;
  }
}
