import 'package:flutter/material.dart';

class EntradaCkeckBox extends StatefulWidget {
  @override
  _EntradaCkeckBoxState createState() => _EntradaCkeckBoxState();
}

class _EntradaCkeckBoxState extends State<EntradaCkeckBox> {

  bool _comidaBrasileira = false;
  bool _comidaMexicana = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de dados")
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            CheckboxListTile(
              title: Text ("Comida Brsileira"),
              subtitle: Text("A melhor Comida do Mundo"),
              activeColor: Colors.red,
              //selected: true,
              //secondary: Icon(Icons.add_box),
              value: _comidaBrasileira,
              onChanged: (bool valor){
                _comidaBrasileira = valor;
              },
            ),

            CheckboxListTile(
              title: Text ("Comida Mexicana"),
              subtitle: Text("A melhor Comida do Mundo"),
              //activeColor: Colors.red,
              //selected: true,
              //secondary: Icon(Icons.add_box),
              value: _comidaMexicana,
              onChanged: (bool valor){
                _comidaMexicana = valor;
              },
            ),
            RaisedButton(
              child: Text(
                  "Salvar",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              onPressed: (){
                print(
                  "Comida Brasileira: " + _comidaBrasileira.toString() +
                  "Comida Mexicana: " + _comidaMexicana.toString()
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
