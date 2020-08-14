import 'package:flutter/material.dart';
import 'AnimacaoExplicita.dart';
import 'AnimacaoImplicita.dart';
import 'AnimacaoTween.dart';
import 'CriandoAnimacoesBasicas.dart';
import 'MaisSobreAnimacoes.dart';

void main(){
  runApp(MaterialApp(
    //home: AnimacaoImplicita(),
    //home: CriandoAnimacoesBasicas(),
    //home: AnimacaoTween(),
    //home: AnimacaoExplicita(),
    home: MaisSobreAnimacoes(),
    debugShowCheckedModeBanner: false,
  ));
}