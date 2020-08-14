import 'package:cloud_firestore/cloud_firestore.dart';

class Noticia{

  String _id;
  String _estado;
  String _titulo;
  String _descricao;
  List<String> _fotos;

  Noticia();

  Noticia.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot.documentID;
    this.estado = documentSnapshot["estado"];
    this.titulo     = documentSnapshot["titulo"];
    this.descricao  = documentSnapshot["descricao"];
    this.fotos  = List<String>.from(documentSnapshot["fotos"]);

  }

  Noticia.gerarId(){

    Firestore db = Firestore.instance;
    CollectionReference noticias = db.collection("minhas_noticias");
    this.id = noticias.document().documentID;

    this.fotos = [];

  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "id" : this.id,
      "estado" : this.estado,
      "titulo" : this.titulo,
      "descricao" : this.descricao,
      "fotos" : this.fotos,
    };

    return map;

  }

  List<String> get fotos => _fotos;

  set fotos(List<String> value) {
    _fotos = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}