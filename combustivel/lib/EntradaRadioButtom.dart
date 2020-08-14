import 'package:flutter/material.dart';

class EntradaRadioButtom extends StatefulWidget {
  @override
  _EntradaRadioButtomState createState() => _EntradaRadioButtomState();
}

class _EntradaRadioButtomState extends State<EntradaRadioButtom> {

  String _escolhaUsuario;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de Dados"),
      ),
      body: Container(
        child: Row(
          children: <Widget>[

            RadioListTile(
              title: Text ("Masculino"),
              value: "m",
              groupValue: _escolhaUsuario,
              onChanged: (String escolha){
                setState((){
                  _escolhaUsuario = escolha;
                });
              }
            ),

            RadioListTile(
                title: Text ("Feminino"),
                value: "f",
                groupValue: _escolhaUsuario,
                onChanged: (String escolha){
                  setState((){
                    _escolhaUsuario = escolha;
                  });
                }
            ),

            RadioListTile(
                title: Text ("Outros"),
                value: "o",
                groupValue: _escolhaUsuario,
                onChanged: (String escolha){
                  setState((){
                    _escolhaUsuario = escolha;
                  });
                }
            ),

            RaisedButton(
              child: Text(
                "Salvar",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              onPressed: (){
                print("Resultado: " + _escolhaUsuario);
              },
            ),

            /*
            Text("Masculino"),
            Radio(
                value: "m",
                groupValue: _escolhaUsuario,
                onChanged: (String escolha){
                  setState((){
                    _escolhaUsuario = escolha;
                  });
                  print("resultado: " + escolha);
                }
            ),

            Text("Feminino"),
            Radio(
                value: "f",
                groupValue: _escolhaUsuario,
                onChanged: (String escolha){
                  setState((){
                    _escolhaUsuario = escolha;
                  });
                  print("resultado: " + escolha);
                }
            )
            */

          ],
        ),
      ),
    );
  }
}
