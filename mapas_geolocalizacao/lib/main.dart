import 'package:flutter/material.dart';
import 'Home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Mapas e geolocalização",
    home: Home(),
  ));
}
