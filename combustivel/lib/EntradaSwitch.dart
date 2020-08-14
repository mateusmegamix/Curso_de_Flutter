import "package:flutter/material.dart";

class EntradaSwitch extends StatefulWidget {
  @override
  _EntradaSwitchState createState() => _EntradaSwitchState();
}

class _EntradaSwitchState extends State<EntradaSwitch> {

  bool _escolhaUsuario = false;
  bool _escolhaConfiguracao = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrada de Dados")
    ),
      body: Container(
        child: Row(
          children: <Widget>[

            SwitchListTile(
              title: Text("Receber Notficações"),
                value: _escolhaUsuario,
                onChanged: (bool valor) {
                  setState(() {
                    _escolhaUsuario = valor;
                  });
                }
            ),

            SwitchListTile(
                title: Text("Carregar Imagens Automaticamente"),
                value: _escolhaConfiguracao,
                onChanged: (bool valor) {
                  setState(() {
                    _escolhaConfiguracao = valor;
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
                if(_escolhaUsuario){
                  print("escolha: Ativar Notificações");
                }else{
                  print("escolha: Não Ativar Notificações");
                }
                //print("Resultado: " + _escolhaUsuario.toString());
              },
            ),

            /*

            Switch(
                value: _escolhaUsuario,
                onChanged: (bool valor) {
                  setState(() {
                    _escolhaUsuario = valor;
                  });
                }
            ),
            Text("Receber Notificações")

             */

          ],
        ),
    ),
    );
  }
}
