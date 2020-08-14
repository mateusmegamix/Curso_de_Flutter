import 'package:flutter/material.dart';
import 'package:am4_noticias/Home.dart';
import 'RouteGenerator.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final ThemeData temaIOS =
      ThemeData(primaryColor: Colors.grey[200], accentColor: Color(0xff25D366));

  final ThemeData temaPadrao = ThemeData(
      primaryColor: Color(0xffd50000), accentColor: Color(0xff25D366));

  runApp(MaterialApp(
    home: Home(),
    theme: Platform.isIOS ? temaIOS : temaPadrao,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}
