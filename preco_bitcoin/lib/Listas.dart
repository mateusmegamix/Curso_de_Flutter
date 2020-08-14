import 'package:flutter/material.dart';

class Listas extends StatefulWidget {
  @override
  _ListasState createState() => _ListasState();
}

class _ListasState extends State<Listas> {

  List _itens = [];

  void _carregarItens(){

    _itens = [];
    for(int i=0; i<=10; i++){
      Map<dynamic, dynamic> item = Map();
      item["titulo"] = "Título ${i} Lorem ipsum dolor sit amet.";
      item["descricao"] = "Descrição ${i} ipsum dolor sit amet.";
      _itens.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {

    _carregarItens();

    return Scaffold(
      appBar: AppBar(
        title: Text("Listas"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _itens.length,
            itemBuilder: (context, indice){
              return ListTile(
                onTap: (){
                  //print("clique com onTap");
                  showDialog(
                      context: context,
                    builder: (context){
                        return AlertDialog(
                          title: Text(_itens[indice]["titulo"]),
                          titlePadding: EdgeInsets.all(20),
                          titleTextStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                          content: Text(_itens[indice]["descricao"]),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: (){
                                print("Selecionado sim");
                                Navigator.pop(context);
                              },
                              child: Text("Sim"),
                            ),

                            FlatButton(
                              onPressed: (){
                                print("Selecionado não");
                                Navigator.pop(context);
                              },
                              child: Text("Não"),
                            )
                          ],
                          //backgroundColor: Colors.orange,
                        );
                    }
                  );
                },
                onLongPress: (){
                  //print("clique com onLongPress");
                },
                title: Text (_itens[indice]["titulo"]),
                subtitle: Text(_itens[indice]["descricao"]),
              );
            }
        ),
      ),
    );
  }
}
