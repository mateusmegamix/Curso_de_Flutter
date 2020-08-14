import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:am4_noticias/util/Config.dart';
import 'package:am4_noticias/widgets/ItemNoticia.dart';
import 'model/Noticia.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DropdownMenuItem<String>> _listaItensDropEstados;

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _itemSelecionadoEstado;

  String _emailUsuario = "";

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }

  List<String> itensMenu = [
    "Minhas Notícias",
    "Deslogar"
  ];

  _escolhaMenuItem(String itemEscolhido) {
    //print("Item escolhido: " + itemEscolhido);

    switch (itemEscolhido) {
      case "Minhas Notícias":
        Navigator.pushNamed(context, "/minhasnoticias");
        break;
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

    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  _CarregarItensDropdown() {
    _listaItensDropEstados = Config.getEstados();
  }

  Future<Stream<QuerySnapshot>> _adicionarListenerNoticias() async {
    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db.collection("noticias").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _filtrarNoticias() async {
    Firestore db = Firestore.instance;
    Query query = db.collection("noticias");

    if(_itemSelecionadoEstado != null){
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _CarregarItensDropdown();
    _verificaUsuarioLogado();
    _recuperarDadosUsuario();
    _adicionarListenerNoticias();
  }

  @override
  Widget build(BuildContext context) {
    var carregandodados = Center(
      child: Column(
        children: <Widget>[
          Text("Carregando Anúncios"),
          CircularProgressIndicator()
        ],
      ),
    );
    int _indiceAtual = 0;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              "imagens/logo.png",
              width: 60,
              height: 100,
            ),
            Text(
              "  Notícias",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
        elevation: Platform.isIOS ? 0 : 4,
        backgroundColor: Colors.red,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                      child: Center(
                    child: DropdownButton(
                      iconEnabledColor: Colors.red,
                      value: _itemSelecionadoEstado,
                      items: _listaItensDropEstados,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                      onChanged: (estado) {
                        setState(() {
                          _itemSelecionadoEstado = estado;
                          _filtrarNoticias();
                        });
                      },
                    ),
                  )),
                ),
                Container(
                  color: Colors.red,
                  width: 1,
                  height: 50,
                ),
              ],
            ),
            StreamBuilder(
              stream: _controller.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return carregandodados;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    QuerySnapshot querySnapshot = snapshot.data;

                    if (querySnapshot.documents.length == 0) {
                      return Container(
                        padding: EdgeInsets.all(25),
                        child: Text(
                          "Nenhuma notícia!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return Expanded(

                      child: ListView.builder(

                          itemCount: querySnapshot.documents.length,
                          itemBuilder: (_, indice) {
                            List<DocumentSnapshot> noticias =
                                querySnapshot.documents.toList();
                            DocumentSnapshot documentSnapshot =
                                noticias[indice];
                            Noticia noticia =
                            Noticia.fromDocumentSnapshot(documentSnapshot);

                            return ItemNoticia(
                                noticia: noticia,
                                onTapItem: () {
                              Navigator.pushNamed(context, "/detalhes", arguments: noticia);
                            },
                            );
                          }),
                    );
                }
                return Container();
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: (indice) {
            setState(() {
              _indiceAtual = indice;
            });
            switch (_indiceAtual) {
              case 0:
                Navigator.pushNamedAndRemoveUntil(
                    context, "/home", (_) => false);
                break;
              case 1:
                Navigator.pushNamedAndRemoveUntil(
                    context, "/noticias", (_) => false);
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.red,
          items: [
            BottomNavigationBarItem(
                //backgroundColor: Colors.orange,
                title: Text("Notícias"),
                icon: Icon(Icons.event_note)),
            BottomNavigationBarItem(
                //backgroundColor: Colors.green,
                title: Text("Adicionar Noticia"),
                icon: Icon(Icons.add_box)),
          ]),
    );
  }
}
