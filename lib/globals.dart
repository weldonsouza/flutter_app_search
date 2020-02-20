library my_prj.globals;

import 'dart:ui';
import 'package:flutter/material.dart';

//Cor verde
var colorGreenLight = Color(0xff80CBC4);
var colorGreenDark = Color(0xFF4EC5AC);

const String url_api = "https://my-json-server.typicode.com/weldonsouza/api_teste/posts/";

mediaQuery(BuildContext context, double value) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  Size size = mediaQuery.size;
  return size.height * value;
}