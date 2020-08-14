import 'package:brasil_fields/modelos/estados.dart';
import 'package:flutter/material.dart';

class Config {

  static List<DropdownMenuItem<String>> getEstados(){
    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    listaItensDropEstados.add(
        DropdownMenuItem(child: Text(
          "Região", style: TextStyle(color: Colors.green),
        ), value: null)
    );

    for(var estado in Estados.listaEstadosAbrv){
      listaItensDropEstados.add(
          DropdownMenuItem(child: Text(estado), value: estado,)
      );
    }

    return listaItensDropEstados;
  }
}