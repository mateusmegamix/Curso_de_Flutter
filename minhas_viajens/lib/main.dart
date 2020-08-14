import 'package:flutter/material.dart';
import 'Home.dart';
import 'SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Minhas viajens",
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
  ));
}