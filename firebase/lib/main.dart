import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

void main() async {

  //Firestore db = Firestore.instance;

  //db.collection("usuarios").document("003").delete();
  /*
  DocumentSnapshot snapshot = await db.collection("usuarios")
      .document("002")
      .get();

  var dados = snapshot.data;
  print("dados nome: " + dados["nome"] + " idade: " + dados["idade"] );
  */
  /*
  QuerySnapshot querySnapshot = await db
      .collection("usuarios")
      .getDocuments();*/

  //print("dados usuarios: " + querySnapshot.documents.toString() );
  /*
  for( DocumentSnapshot item in querySnapshot.documents ){
    var dados = item.data;
    print("dados usuarios: " + dados["nome"] + " - " + dados["idade"] );
  }*/

  /*
  db.collection("usuarios").snapshots().listen(
      ( snapshot ){

        for( DocumentSnapshot item in snapshot.documents ){
          var dados = item.data;
          print("dados usuarios: " + dados["nome"] + " - " + dados["idade"] );
        }

      }
  );
  */

  /*
  //verificação de usuarios LOGIN

  FirebaseAuth auth = FirebaseAuth.instance;
  String email = "mateusp.1996@gmail.com";
  String senha = "123456";


  auth.createUserWithEmailAndPassword(
      email: email,
      password: senha
  ).then((firebaseUser){
    print("novo usuario: sucesso!! e-mail: " + firebaseUser.email);
  }).catchError((erro){
    print("novo usuario: " + erro.toString());
  });
  */

  //Logando usuario // se colocar email errado usuario não loga
  /*
  auth.signInWithEmailAndPassword(
      email: email,
      password: senha
  ).then((firebaseUser){
    print ("Logar usuario: sucesso! e-mail: " + firebaseUser.email);
  }).catchError((erro){
    print("Logar usuario: erro" + erro.toString());
  });
  */

  /* verifica se usuario está logado
  FirebaseUser usuarioAtual = await auth.currentUser();
  if(usuarioAtual != null){//logado
    print("Logado" + usuarioAtual.email);
  }else{
    print("usuario atual está deslogado");
  }
  */

  //auth.signOut();

  runApp(MaterialApp(
    home: Home(),
  ));

}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ImagePicker picker = ImagePicker();
  File _imagem;
  String _statusUpload = "Upload não iniciado";
  String _urlImagemRecuperada = null;

  Future _recuperarImagem(bool daCamera) async{
    File imgSelecionada;

    if (daCamera) {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      imgSelecionada = File(pickedFile.path);
    } else {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      imgSelecionada = File(pickedFile.path);
    }

    setState(() {
      _imagem = imgSelecionada;
    });
  }

  Future _uploadImagem() async {

    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("fotos")
        .child("foto1.jpg");

    //Fazer o upload
    StorageUploadTask task = arquivo.putFile(_imagem);

    //controlar
    task.events.listen((StorageTaskEvent storageEvent){

      if(storageEvent.type == StorageTaskEventType.progress){
        setState(() {
          _statusUpload = "Em progresso";
        });
      }else if(storageEvent.type == StorageTaskEventType.success){
        setState(() {
          _statusUpload = "Upload realizado com sucesso";
        });
      }
    });

    //Recuprar url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

    Future _recuperarUrlImagem(StorageTaskSnapshot snaphot) async{
      String url = await snaphot.ref.getDownloadURL();
      print("resultado url: " + url);
      setState(() {
        _urlImagemRecuperada = url;
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar imagem"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(_statusUpload),
            RaisedButton(
              child: Text("Camera"),
              onPressed: (){
                _recuperarImagem(true);
              },
            ),
            RaisedButton(
              child: Text("Galeria"),
              onPressed: (){
                _recuperarImagem(false);
              },
            ),
            _imagem == null
            ? Container()
                : Image.file(_imagem),
            _imagem == null
                ? Container()
                : RaisedButton(
              child: Text("Upload Storage"),
              onPressed: (){
                _uploadImagem();
              },
            ),
            _urlImagemRecuperada == null
                ? Container()
                : Image.network(_urlImagemRecuperada)
          ],
        ),
      ),
    );
  }
}


