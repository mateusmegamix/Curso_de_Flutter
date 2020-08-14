import 'package:flutter/material.dart';

import 'Home.dart';
import 'Listas.dart';
import 'HomeState.dart';

void main(){
  runApp(MaterialApp(
    home: Home(),
    //home: Listas(),
    //home: HomeState(),
    debugShowCheckedModeBanner: false,
  ));
}