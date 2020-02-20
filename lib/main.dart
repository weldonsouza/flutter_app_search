import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_search/controller.dart';
import 'package:flutter_app_search/globals.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set portrait orientation
    SystemChrome.setPreferredOrientations ([
      DeviceOrientation.portraitUp
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        accentColor: colorGreenDark,
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
