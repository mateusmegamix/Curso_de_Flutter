import 'package:flutter/material.dart';

class Excluir extends StatefulWidget {
  @override
  _ExcluirState createState() => _ExcluirState();
}

class _ExcluirState extends State<Excluir> {

  List _lista = ["Mateus", "Camila", "Caroline", "Cleide"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("widgets")
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _lista.length,
              itemBuilder: (context, index){

                final item = _lista[index];

                return Dismissible(

                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),

                  secondaryBackground: Container(
                    color: Colors.green,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),

                  direction: DismissDirection.horizontal,
                  onDismissed: (direction){
                    print("direcao: " + direction.toString());
                  },

                  key: Key(item),
                  child: ListTile(
                    title: Text(item),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}
