import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:am4_noticias/model/Noticia.dart';
import 'package:am4_noticias/widgets/ItemNoticia.dart';


class MeusProdutos extends StatefulWidget {
  @override
  _MeusProdutosState createState() => _MeusProdutosState();
}

class _MeusProdutosState extends State<MeusProdutos> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado;

  _recuperaDadosUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

  }

  Future<Stream<QuerySnapshot>> _adicionarListenerNoticias() async {

    await _recuperaDadosUsuarioLogado();

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("minhas_noticias")
        .document( _idUsuarioLogado )
        .collection("noticias")
        .snapshots();

    stream.listen((dados){
      _controller.add( dados );
    });

  }

  _removerNoticia(String idNoticia){

    Firestore db = Firestore.instance;
    db.collection("minhas_noticias")
        .document( _idUsuarioLogado )
        .collection("noticias")
        .document( idNoticia )
        .delete().then((_){


          db.collection("noticias")
              .document(idNoticia)
              .delete();
    });

  }

  List<String> itensMenu = ["Deslogar"];

  _escolhaMenuItem(String itemEscolhido) {
    //print("Item escolhido: " + itemEscolhido);

    switch (itemEscolhido) {
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificaUsuarioLogado();
    _recuperaDadosUsuarioLogado();
    _adicionarListenerNoticias();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(children: <Widget>[
        Text("Carregando notícias"),
        CircularProgressIndicator()
      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("Minhas Notícias", style: TextStyle(color: Colors.white, fontSize: 20),)
          ],
        ),
        elevation: Platform.isIOS ? 0 : 4,
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
          icon: Icon(Icons.add),
          label: Text("Adicionar"),
          onPressed: (){

            Navigator.pushNamedAndRemoveUntil(context, "/noticias", (_) => false);

          }),
      body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot){

            switch( snapshot.connectionState ){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return carregandoDados;
                break;
              case ConnectionState.active:
              case ConnectionState.done:

                if(snapshot.hasError)
                  return Text("Erro ao carregar os dados!");

                QuerySnapshot querySnapshot = snapshot.data;

                return ListView.builder(
                  itemCount: querySnapshot.documents.length,
                  itemBuilder: (_, indice){

                    List<DocumentSnapshot> noticias = querySnapshot.documents.toList();
                    DocumentSnapshot documentSnapshot = noticias[indice];
                    Noticia noticia = Noticia.fromDocumentSnapshot(documentSnapshot);

                    return ItemNoticia(
                      noticia: noticia,
                      onPressedRemover:(){
                        showDialog(
                            context: context,
                          builder: (context){
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("Deseja realmente excluir a notícia?"),
                                actions: <Widget>[

                                  FlatButton(
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                        color: Colors.grey
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                  FlatButton(
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(
                                          color: Colors.red
                                      ),
                                    ),
                                    onPressed: (){
                                      _removerNoticia(noticia.id);
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                ],
                              );
                          }
                        );
                      },
                    );
                  },
                );
            }
            return Container();
          },
      )
    );
  }
}
