import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:am4_noticias/widgets/BotaoCustomizado.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:am4_noticias/widgets/InputCustomizado.dart';
import 'package:validadores/Validador.dart';
import 'package:am4_noticias/model/Noticia.dart';
import 'package:am4_noticias/util/Config.dart';

class Produto extends StatefulWidget {
  @override
  _ProdutoState createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto> {
  List<File> _listaImagens = List();
  List<DropdownMenuItem<String>> _listaItensDropEstados = List();
  final _formKey = GlobalKey<FormState>();
  Noticia _noticia;
  BuildContext _dialogContext;

  String _itemSelecionadoEstado;

  _selecionarImagemGaleria() async {
    File imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  _abrirDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Salvando notícia...")
            ],
          ));
        });
  }

  _salvarNoticia() async {
    _abrirDialog(_dialogContext);

    //Upload imagens no Storage
    await _uploadImagens();

    //salvar no firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuarioLogado = usuarioLogado.uid;

    Firestore db = Firestore.instance;
    db
        .collection("minhas_noticias")
        .document(idUsuarioLogado)
        .collection("noticias")
        .document(_noticia.id)
        .setData(_noticia.toMap())
        .then((_) {
      //salvar anúncio puvlico
      db
          .collection("noticias")
          .document(_noticia.id)
          .setData(_noticia.toMap())
          .then((_) {
        Navigator.pop(_dialogContext);

        Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
      });
    });
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo =
          pastaRaiz.child("minhas_noticias").child(_noticia.id).child(nomeImagem);

      StorageUploadTask uploadTask = arquivo.putFile(imagem);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      _noticia.fotos.add(url);
    }
  }

  int _indiceAtual = 1;

  List<String> itensMenu = [
    "Minhas Noticias",
    "Deslogar"
  ];

  _escolhaMenuItem(String itemEscolhido) {
    //print("Item escolhido: " + itemEscolhido);

    switch (itemEscolhido) {
      case "Minhas Noticias":
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

  String _emailUsuario = "";

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }

  Future _verificaUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //auth.signOut();

    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  _CarregarItensDropdown() {

    _listaItensDropEstados = Config.getEstados();
  }

  @override
  void initState() {
    super.initState();
    _verificaUsuarioLogado();
    _recuperarDadosUsuario();
    _CarregarItensDropdown();

    _noticia = Noticia.gerarId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text("Nova Notícia",
                style: TextStyle(color: Colors.white, fontSize: 20)),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FormField<List>(
                    initialValue: _listaImagens,
                    validator: (imagens) {
                      if (imagens.length == 0) {
                        return "Necessário selecionar uma imagem!";
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _listaImagens.length + 1,
                                itemBuilder: (context, indice) {
                                  if (indice == _listaImagens.length) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          _selecionarImagemGaleria();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[400],
                                          radius: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.add_a_photo,
                                                  size: 40,
                                                  color: Colors.grey[100]),
                                              Text(
                                                "Adicionar",
                                                style: TextStyle(
                                                    color: Colors.grey[100]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  if (_listaImagens.length > 0) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Image.file(
                                                            _listaImagens[
                                                                indice]),
                                                        FlatButton(
                                                            child:
                                                                Text("Ecluir"),
                                                            textColor:
                                                                Colors.red,
                                                            onPressed: () {
                                                              setState(() {
                                                                _listaImagens
                                                                    .removeAt(
                                                                        indice);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              });
                                                            })
                                                      ],
                                                    ),
                                                  ));
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              FileImage(_listaImagens[indice]),
                                          child: Container(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.4),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Container();
                                }),
                          ),
                          if (state.hasError)
                            Container(
                                child: Text("${state.errorText}",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 14)))
                        ],
                      );
                    },
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            value: _itemSelecionadoEstado,
                            hint: Text("Estados"),
                            onSaved: (estado) {
                              _noticia.estado = estado;
                            },
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            items: _listaItensDropEstados,
                            validator: (valor) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: "Campo obrigatório")
                                  .valido(valor);
                            },
                            onChanged: (valor) {
                              _itemSelecionadoEstado = valor;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: InputCustomizado(
                      hint: "Título",
                      onSaved: (titulo) {
                        _noticia.titulo = titulo;
                      },
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .valido(valor);
                      },
                      controller: null,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: InputCustomizado(
                      hint: "Descrição",
                      onSaved: (descricao) {
                        _noticia.descricao = descricao;
                      },
                      maxLines: null,
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .maxLength(200, msg: "Máximo de 200 caracteres")
                            .valido(valor);
                      },
                      controller: null,
                    ),
                  ),
                  BotaoCustomizado(
                    texto: "Cadastrar Notícia",
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //salva campos
                        _formKey.currentState.save();

                        //Configura dialog context
                        _dialogContext = context;

                        //salvar noticia
                        _salvarNoticia();
                      }
                    },
                  ),
                ],
              )),
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
                title: Text("Noticias"),
                icon: Icon(Icons.event_note)),
            BottomNavigationBarItem(
                //backgroundColor: Colors.green,
                title: Text("Adicionar Noticia"),
                icon: Icon(Icons.add_box)),
          ]),
    );
  }
}
