import 'package:flutter/material.dart';
import 'Cadastro_Usuario.dart';
import 'Detalhes.dart';
import 'Home.dart';
import 'Login.dart';
import 'MinhasNoticias.dart';
import 'Noticias.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/usuario":
        return MaterialPageRoute(builder: (_) => Cadastro_Usuario());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/noticias":
        return MaterialPageRoute(builder: (_) => Produto());
      case "/minhasnoticias":
        return MaterialPageRoute(builder: (_) => MeusProdutos());
      case "/detalhes":
        return MaterialPageRoute(builder: (_) => Detalhes(args));

      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
