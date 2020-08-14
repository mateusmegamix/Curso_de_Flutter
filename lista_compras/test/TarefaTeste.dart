import 'package:flutter/material.dart';

class Tarefa extends StatefulWidget {
  @override
  _TarefaState createState() => _TarefaState();
}

class _TarefaState extends State<Tarefa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FloatingActionButton"),
      ),
      body: Text("Conteudo"),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 6,
        icon: Icon(Icons.add_shopping_cart),
        label: Text("Adicionar"),
        //shape: BeveledRectangleBorder(
        //  borderRadius: BorderRadius.circular(8)
        //),
        //mini: true,
        /*child: Icon(Icons.add),
          onPressed: (){
            print("Resultado botão pressionado!");
          }*/
      ),
      bottomNavigationBar: BottomAppBar(
        //shape: CircularNotchedRectangle(),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.add),
              ),
            ],
          ),
      ),
    );
  }
}
