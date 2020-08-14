import "package:flutter/material.dart";

class EntradaSlider extends StatefulWidget {
  @override
  _EntradaSlider createState() => _EntradaSlider();
}

class _EntradaSlider extends State<EntradaSlider> {

  double valor = 5;
  String label = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Entrada de Dados")
      ),
      body: Container(
        padding: EdgeInsets.all(60),
        child:  Column(
          children: <Widget>[

            Slider(
                value: valor,
                min: 0,
                max: 10,
                label: "valor selecionado ",
                divisions: 5,
                activeColor: Colors.red,
                inactiveColor: Colors.black12,
                onChanged: (double novoValor){
                  setState(){
                    valor = novoValor;
                    label = novoValor.toString();
                  }
                  //print("Valor selecionado: " + novoValor.toString());
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
                print("Valor selecionado: " + valor.toString());
              },
            )

          ],
        ),
      )
    );
  }
}